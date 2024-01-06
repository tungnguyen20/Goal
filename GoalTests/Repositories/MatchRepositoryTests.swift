//
//  MatchRepositoryTests.swift
//  GoalTests
//
//  Created by Tung Nguyen on 05/01/2024.
//

import XCTest
import Combine
import Networking
@testable import Goal

final class MatchRepositoryTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    var sut: MatchRepository!
    var matchService: MockMatchService!
    var teamService: MockTeamService!
    var matchDatabase: MockMatchDatabase!
    var teamDatabase: MockTeamDatabase!
    
    override func setUpWithError() throws {
        cancellables = .init()
        matchService = MockMatchService()
        teamService = MockTeamService()
        matchDatabase = MockMatchDatabase()
        teamDatabase = MockTeamDatabase()
        
        sut = MatchRepository(matchService: matchService, teamService: teamService, matchDatabase: matchDatabase, teamDatabase: teamDatabase)
    }
    
    func getMockMatches() -> MatchListResponse {
        return try! JSONDecoder().decode(MatchListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "matches", withExtension: "json")!))
    }
    
    func getMockTeams() -> TeamListResponse {
        return try! JSONDecoder().decode(TeamListResponse.self,
                                         from: try! Data(contentsOf: Bundle(for: Self.self).url(forResource: "teams", withExtension: "json")!))
    }
    
    
    func test_getAllMatches() {
        var matchList: MatchListObject?
        var error: Error?
        
        let expectation0 = self.expectation(description: "getAllMatches_when_service_failed_and_database_empty")
        matchService.matches = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        teamService.teams = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        matchDatabase.matches = Result.success([]).publisher.eraseToAnyPublisher()
        teamDatabase.teams = Result.success([]).publisher.eraseToAnyPublisher()
        
        sut.getMatchList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation0.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation0], timeout: 1)
        
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 0)
        XCTAssertEqual(matchList?.upcoming.count, 0)
        matchList = nil
        error = nil
        
        let expectation1 = self.expectation(description: "getAllMatches_when_service_success")
        matchService.matches = Result.success(getMockMatches()).publisher.eraseToAnyPublisher()
        teamService.teams = Result.success(getMockTeams()).publisher.eraseToAnyPublisher()
        
        sut.getMatchList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation1.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation1], timeout: 1)
        
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 2)
        XCTAssertEqual(matchList?.upcoming.count, 2)
        matchList = nil
        error = nil
        
        matchService.matches = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        teamService.teams = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        
        let expectation2 = self.expectation(description: "getAllMatches_when_service_failed_and_database_has_data")
        
        sut.getMatchList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation2.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation2], timeout: 1)
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 2)
        XCTAssertEqual(matchList?.upcoming.count, 2)
    }
    
    func test_getTeamMatches() {
        var matchList: MatchListObject?
        var error: Error?
        
        let expectation0 = self.expectation(description: "getTeamMatches_when_service_failed")
        matchService.matches = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        teamService.teams = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        matchDatabase.matches = Result.success([]).publisher.eraseToAnyPublisher()
        teamDatabase.teams = Result.success([]).publisher.eraseToAnyPublisher()
        
        sut.getTeamMatches(name: "A")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation0.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation0], timeout: 1)
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 0)
        XCTAssertEqual(matchList?.upcoming.count, 0)
        
        let expectation1 = self.expectation(description: "getTeamMatches_when_service_success")
        
        matchService.matches = Result.success(getMockMatches()).publisher.eraseToAnyPublisher()
        teamService.teams = Result.success(getMockTeams()).publisher.eraseToAnyPublisher()
        
        sut.getTeamMatches(name: "A")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation1.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation1], timeout: 1)
        
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 2)
        XCTAssertEqual(matchList?.upcoming.count, 1)
        matchList = nil
        error = nil
        
        matchService.matches = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        teamService.teams = Result.failure(ApiError.decodeFailed).publisher.eraseToAnyPublisher()
        
        let expectation2 = self.expectation(description: "getTeamMatches_when_service_failed_and_database_has_data")
        
        sut.getTeamMatches(name: "A")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation2.fulfill()
            }, receiveValue: { value in
                matchList = value
            })
            .store(in: &cancellables)
        
        
        wait(for: [expectation2], timeout: 1)
        XCTAssertNil(error)
        XCTAssertEqual(matchList?.previous.count, 2)
        XCTAssertEqual(matchList?.upcoming.count, 1)
    }
    
    
}
