//
//  MatchesViewModelTests.swift
//  GoalTests
//
//  Created by Tung Nguyen on 07/01/2024.
//

import Foundation
import XCTest
import Combine
import Networking
@testable import Goal

final class MatchesViewModelTests: XCTestCase {
    var sut: MatchesViewModel!
    var repository: MockMatchRepository!
    
    override func setUpWithError() throws {
        repository = MockMatchRepository()
        sut = MatchesViewModel(matchRepository: repository)
    }
    
    func getMockMatches() -> MatchListResponse {
        return try! JSONDecoder().decode(MatchListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "matches", withExtension: "json")!))
    }
    
    func getMockTeams() -> TeamListResponse {
        return try! JSONDecoder().decode(TeamListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "teams", withExtension: "json")!))
    }
    
    
    func testMapDataFromRepositoryWhenEmpty() {
        repository.matches = Result.success(.init(upcoming: [], previous: [])).publisher.eraseToAnyPublisher()
        sut.getAllMatches()
        
        _ = sut.$previousMatches
            .sink { matches in
                XCTAssertEqual(matches.count, 0)
            }
        
        _ = sut.$upcomingMatches
            .sink { matches in
                XCTAssertEqual(matches.count, 0)
            }
    }
    
    func testMapDataFromRepositoryWhenHasData() {
        let matchItem = MatchItem(match: getMockMatches().matches.previous[0],
                                  home: getMockTeams().teams[0],
                                  away: getMockTeams().teams[1])
        let matches = MatchListObject(upcoming: [matchItem], previous: [matchItem, matchItem])
        repository.matches = Result.success(matches).publisher.eraseToAnyPublisher()
        sut.getAllMatches()
        
        _ = sut.$upcomingMatches
            .sink { matches in
                XCTAssertEqual(matches.count, 1)
            }
        
        _ = sut.$previousMatches
            .sink { matches in
                XCTAssertEqual(matches.count, 2)
            }
    }
    
    func testFilterTeamsWhenHasSelectingTeams() {
        let matches = MatchListObject(
            upcoming: [
                MatchItem(match: getMockMatches().matches.upcoming[0],
                          home: getMockTeams().teams[0],
                          away: getMockTeams().teams[1]),
                MatchItem(match: getMockMatches().matches.upcoming[1],
                          home: getMockTeams().teams[1],
                          away: getMockTeams().teams[2])
            ],
            previous: [
                MatchItem(match: getMockMatches().matches.previous[0],
                          home: getMockTeams().teams[0],
                          away: getMockTeams().teams[1]),
                MatchItem(match: getMockMatches().matches.previous[1],
                          home: getMockTeams().teams[1],
                          away: getMockTeams().teams[2])
            ]
        )
        repository.matches = Result.success(matches).publisher.eraseToAnyPublisher()
        sut.onFilterTeamsChanged(teams: [getMockTeams().teams[0]])
        
        _ = sut.$previousMatches
            .dropFirst()
            .sink { matches in
                XCTAssertEqual(matches.count, 1)
            }
        
        _ = sut.$upcomingMatches
            .dropFirst()
            .sink { matches in
                XCTAssertEqual(matches.count, 1)
            }
    }
    
    func testFilterTeamsWhenTeamsNotSelected() {
        let matches = MatchListObject(
            upcoming: [
                MatchItem(match: getMockMatches().matches.upcoming[0],
                          home: getMockTeams().teams[0],
                          away: getMockTeams().teams[1]),
                MatchItem(match: getMockMatches().matches.upcoming[1],
                          home: getMockTeams().teams[1],
                          away: getMockTeams().teams[2])
            ],
            previous: [
                MatchItem(match: getMockMatches().matches.previous[0],
                          home: getMockTeams().teams[0],
                          away: getMockTeams().teams[1]),
                MatchItem(match: getMockMatches().matches.previous[1],
                          home: getMockTeams().teams[1],
                          away: getMockTeams().teams[2])
            ]
        )
        repository.matches = Result.success(matches).publisher.eraseToAnyPublisher()
        sut.onFilterTeamsChanged(teams: [])
        
        _ = sut.$previousMatches
            .dropFirst()
            .sink { matches in
                XCTAssertEqual(matches.count, 2)
            }
        
        _ = sut.$upcomingMatches
            .dropFirst()
            .sink { matches in
                XCTAssertEqual(matches.count, 2)
            }
    }
    
}
