//
//  ApiClient.swift
//  Goal
//
//  Created by Tung Nguyen on 07/01/2024.
//

import Foundation
import Networking
import Combine

protocol ApiServiceProtocol {
    func getAllTeams() -> AnyPublisher<TeamListResponse, ApiError>
    func getAllMatches() -> AnyPublisher<MatchListResponse, ApiError>
}

class ApiService: ApiClient, ApiServiceProtocol {
    
    func getAllTeams() -> AnyPublisher<TeamListResponse, ApiError> {
        return request(ApiEndpoint.getTeams)
    }
    
    func getAllMatches() -> AnyPublisher<MatchListResponse, ApiError> {
        return request(ApiEndpoint.getMatches)
    }
    
}
