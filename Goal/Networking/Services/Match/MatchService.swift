//
//  MatchService.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Networking
import Combine

protocol MatchServiceProtocol {
    func getAllMatches() -> AnyPublisher<MatchListResponse, ApiError>
}

class MatchService: ApiClient, MatchServiceProtocol {

    func getAllMatches() -> AnyPublisher<MatchListResponse, ApiError> {
        return request(MatchEndpoint.getMatches)
    }
    
}
