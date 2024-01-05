//
//  MatchEndpoint.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Networking

enum MatchEndpoint: Endpoint {
    case getMatches
    
    var baseURL: URL {
        return URL(string: Configuration.baseApiUrl)!
    }
    
    var path: String {
        switch self {
        case .getMatches:
            return "/teams/matches"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var method: Networking.HTTPMethod {
        switch self {
        case .getMatches:
            return .get
        }
    }
    
    var parameters: Networking.Parameters {
        return .plain
    }
}
