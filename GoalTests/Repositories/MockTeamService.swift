//
//  MockTeamService.swift
//  GoalTests
//
//  Created by Tung Nguyen on 06/01/2024.
//

import Foundation
import Combine
import Networking
@testable import Goal

class MockTeamService: TeamServiceProtocol {    
    
    var teams: AnyPublisher<Goal.TeamListResponse, Networking.ApiError>!

    func getAllTeams() -> AnyPublisher<Goal.TeamListResponse, Networking.ApiError> {
        return teams
    }
    
}
