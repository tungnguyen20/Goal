//
//  MockMatchService.swift
//  GoalTests
//
//  Created by Tung Nguyen on 06/01/2024.
//

import Foundation
import Combine
import Networking
@testable import Goal

class MockMatchService: MatchServiceProtocol {
    
    var matches: AnyPublisher<Goal.MatchListResponse, Networking.ApiError>!
    
    func getAllMatches() -> AnyPublisher<Goal.MatchListResponse, Networking.ApiError> {
        return matches
    }
    
    
}
