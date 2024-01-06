//
//  MockTeamDatabase.swift
//  GoalTests
//
//  Created by Tung Nguyen on 06/01/2024.
//

import Foundation
import Combine
@testable import Goal

class MockTeamDatabase: TeamDatabaseProtocol {
    
    var teams: AnyPublisher<[Goal.Team], Error>!
    
    func getAllTeams() -> AnyPublisher<[Goal.Team], Error> {
        return teams
    }
    
    func save(teams: [Goal.Team]) {
        self.teams = Result.success(teams).publisher.eraseToAnyPublisher()
    }
    
}
