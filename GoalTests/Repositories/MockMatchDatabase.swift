//
//  MockMatchDatabase.swift
//  GoalTests
//
//  Created by Tung Nguyen on 06/01/2024.
//

import Foundation
import Combine
@testable import Goal

class MockMatchDatabase: MatchDatabaseProtocol {
    
    var matches: AnyPublisher<[Goal.Match], Error>!
    
    func getAllMatches() -> AnyPublisher<[Goal.Match], Error> {
        return matches
    }
    
    func save(matches: [Goal.Match]) {
        self.matches = Result.success(matches).publisher.eraseToAnyPublisher()
    }
    
}
