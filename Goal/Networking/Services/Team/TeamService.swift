//
//  TeamService.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Networking
import Combine

protocol TeamServiceProtocol {
    func getAllTeams() -> AnyPublisher<TeamListResponse, ApiError>
}

class TeamService: ApiClient, TeamServiceProtocol {
    
    func getAllTeams() -> AnyPublisher<TeamListResponse, ApiError> {
        return request(TeamEndpoint.getTeams)
    }
    
}
