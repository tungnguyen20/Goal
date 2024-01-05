//
//  MatchService.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Networking
import Combine

class MatchService: ApiClient {

    func getAllMatches() -> AnyPublisher<MatchListResponse, ApiError> {
        return request(MatchEndpoint.getMatches)
    }
    
}
