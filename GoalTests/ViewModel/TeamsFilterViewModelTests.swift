//
//  TeamsFilterViewModelTests.swift
//  GoalTests
//
//  Created by Nguyen Tung on 09/01/2024.
//

import Foundation
import Combine
import XCTest
@testable import Goal

class TeamsFilterViewModelTests: XCTestCase {
    
    var sut: TeamsFilterViewModel!
    var repository: MockMatchRepository!
    
    override func setUpWithError() throws {
        repository = MockMatchRepository()
        sut = TeamsFilterViewModel(repository: repository, selectingTeams: [])
    }
    
    func getMockMatches() -> MatchListResponse {
        return try! JSONDecoder().decode(MatchListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "matches", withExtension: "json")!))
    }
    
    func getMockTeams() -> TeamListResponse {
        return try! JSONDecoder().decode(TeamListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "teams", withExtension: "json")!))
    }
    
    func testToggleItem() {
        repository.teams = Result.success(getMockTeams().teams).publisher.eraseToAnyPublisher()
        sut.getAllTeams()

        let team = getMockTeams().teams[0]
        let item = TeamFilterItemViewModel(team: team, isSelecting: false)
        sut.toggleItem(item: item)
        
        XCTAssertEqual(sut.selectingTeams.count, 1)
        XCTAssertTrue(sut.selectingTeams.contains(team))
        
        sut.toggleItem(item: item)
        
        XCTAssertEqual(sut.selectingTeams.count, 0)
        XCTAssertFalse(sut.selectingTeams.contains(team))
    }
    
}
