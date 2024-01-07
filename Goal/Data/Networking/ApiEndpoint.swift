//
//  ApiEndpoint.swift
//  Goal
//
//  Created by Tung Nguyen on 07/01/2024.
//

import Foundation
import Networking

enum ApiEndpoint: Endpoint {
    case getTeams
    case getMatches
    
    var baseURL: URL {
        return URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com")!
    }
    
    var path: String {
        switch self {
        case .getTeams:
            return "/teams"
        case .getMatches:
            return "/teams/matches"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var method: Networking.HTTPMethod {
        switch self {
        case .getTeams:
            return .get
        case .getMatches:
            return .get
        }
    }
    
    var parameters: Networking.Parameters {
        return .plain
    }
}
