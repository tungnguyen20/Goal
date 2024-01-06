//
//  MatchRepository.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import Combine

protocol MatchRepositoryProtocol {
    func getMatchList() -> AnyPublisher<MatchListObject, Never>
    func getTeamMatches(name: String) -> AnyPublisher<MatchListObject, Never>
}

class MatchRepository: MatchRepositoryProtocol {
    let matchService: MatchServiceProtocol
    let teamService: TeamServiceProtocol
    let matchDatabase: MatchDatabaseProtocol
    let teamDatabase: TeamDatabaseProtocol
    
    init(matchService: MatchServiceProtocol, teamService: TeamServiceProtocol, matchDatabase: MatchDatabaseProtocol, teamDatabase: TeamDatabaseProtocol) {
        self.matchService = matchService
        self.teamService = teamService
        self.matchDatabase = matchDatabase
        self.teamDatabase = teamDatabase
    }
    
    func getAllMatches() -> AnyPublisher<[Match], Error> {
        matchService.getAllMatches()
            .map { $0.matches.previous + $0.matches.upcoming }
            .map { [weak self] matches in
                self?.matchDatabase.save(matches: matches)
                return matches
            }
            .catch { error -> AnyPublisher<[Match], Error> in
                return self.matchDatabase.getAllMatches()
            }.eraseToAnyPublisher()
    }
    
    func getAllTeams() -> AnyPublisher<[Team], Error> {
        teamService.getAllTeams()
            .map(\.teams)
            .map { [weak self] teams in
                self?.teamDatabase.save(teams: teams)
                return teams
            }
            .catch { error -> AnyPublisher<[Team], Error> in
                return self.teamDatabase.getAllTeams()
            }.eraseToAnyPublisher()
    }
    
    func getMatchList() -> AnyPublisher<MatchListObject, Never> {
        return Publishers.CombineLatest(
            getAllTeams().replaceError(with: []),
            getAllMatches().replaceError(with: [])
        )
        .map { teams, matches in
            let upcoming = matches
                .filter {
                    guard let date = $0.date.toDate(format: .yyyyMMddHHmmssZ) else {
                        return false
                    }
                    return date >= Date()
                }
                .compactMap {
                    self.getMatchItem(match: $0, teams: teams)
                }
            let previous = matches
                .filter {
                    guard let date = $0.date.toDate(format: .yyyyMMddHHmmssZ) else {
                        return false
                    }
                    return date < Date()
                }
                .compactMap {
                    self.getMatchItem(match: $0, teams: teams)
                }
            return MatchListObject(upcoming: upcoming, previous: previous)
        }
        .eraseToAnyPublisher()
    }
    
    func getTeamMatches(name: String) -> AnyPublisher<MatchListObject, Never> {
        return Publishers.CombineLatest(
            getAllTeams().replaceError(with: []),
            getAllMatches().replaceError(with: [])
        )
        .map { teams, matches in
            let upcoming = matches
                .filter {
                    guard let date = $0.date.toDate(format: .yyyyMMddHHmmssZ) else {
                        return false
                    }
                    return date >= Date() && ($0.away == name || $0.home == name)
                }
                .compactMap {
                    self.getMatchItem(match: $0, teams: teams)
                }
            let previous = matches
                .filter {
                    guard let date = $0.date.toDate(format: .yyyyMMddHHmmssZ) else {
                        return false
                    }
                    return date < Date() && ($0.away == name || $0.home == name)
                }
                .compactMap {
                    self.getMatchItem(match: $0, teams: teams)
                }
            return MatchListObject(upcoming: upcoming, previous: previous)
        }
        .eraseToAnyPublisher()
    }
    
    private func getMatchItem(match: Match, teams: [Team]) -> MatchItem? {
        guard let home = teams.first(where: { $0.name == match.home }),
              let away = teams.first(where: { $0.name == match.away }) else {
            return nil
        }
        return MatchItem(match: match, home: home, away: away)
    }
}
