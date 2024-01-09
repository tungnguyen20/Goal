//
//  MatchesViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Combine

class MatchesViewModel {
    @Published var upcomingMatches: [MatchItemViewModel] = []
    @Published var previousMatches: [MatchItemViewModel] = []
    @Published var filteringTeams: [Team] = []
    var route = PassthroughSubject<MatchesCoordinator.Route, Never>()
    let matchRepository: MatchRepositoryProtocol
    var subscriptions = Set<AnyCancellable>()
    
    init(matchRepository: MatchRepositoryProtocol) {
        self.matchRepository = matchRepository
        
        $filteringTeams
            .dropFirst()
            .sink { [weak self] teams in
                if teams.isEmpty {
                    self?.getAllMatches()
                } else {
                    self?.getMatches(teams: teams)
                }
            }
            .store(in: &subscriptions)
    }
    
    func getAllMatches() {
        matchRepository.getMatchList()
            .replaceError(with: .init(upcoming: [], previous: []))
            .sink { [weak self] matches in
                let upcoming = matches.upcoming.map { MatchItemViewModel(item: $0, isPrevious: false) }
                let previous = matches.previous.map { MatchItemViewModel(item: $0, isPrevious: true) }
                
                self?.upcomingMatches = upcoming
                self?.previousMatches = previous
            }
            .store(in: &subscriptions)
    }
    
    func onFilterTeamsChanged(teams: [Team]) {
        self.filteringTeams = teams
    }
    
    func getMatches(teams: [Team]) {
        matchRepository.getMatches(teams: teams.map(\.name))
            .replaceError(with: .init(upcoming: [], previous: []))
            .sink { [weak self] matches in
                let upcoming = matches.upcoming.map { MatchItemViewModel(item: $0, isPrevious: false) }
                let previous = matches.previous.map { MatchItemViewModel(item: $0, isPrevious: true) }
                
                self?.upcomingMatches = upcoming
                self?.previousMatches = previous
            }
            .store(in: &subscriptions)
    }
    
}
