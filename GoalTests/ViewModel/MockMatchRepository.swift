//
//  MockMatchRepository.swift
//  GoalTests
//
//  Created by Tung Nguyen on 07/01/2024.
//

import Foundation
import Combine
@testable import Goal

class MockMatchRepository: MatchRepositoryProtocol {

    var teams: AnyPublisher<[Goal.Team], Never>!
    var matches: AnyPublisher<Goal.MatchListObject, Never>!

    func getMatchList() -> AnyPublisher<Goal.MatchListObject, Never> {
        return matches
    }
    
    func getTeamMatches(name: String) -> AnyPublisher<Goal.MatchListObject, Never> {
        return matches
    }
    
    func getAllTeams() -> AnyPublisher<[Goal.Team], Never> {
        return teams
    }
    
    func getMatches(teams: [String]) -> AnyPublisher<Goal.MatchListObject, Never> {
        return matches
    }
    
}
