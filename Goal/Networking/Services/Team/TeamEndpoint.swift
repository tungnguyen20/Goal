//
//  TeamEndpoint.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation
import Networking

enum TeamEndpoint: Endpoint {
    case getTeams
    
    var baseURL: URL {
        return URL(string: Configuration.baseApiUrl)!
    }
    
    var path: String {
        switch self {
        case .getTeams:
            return "/teams"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var method: Networking.HTTPMethod {
        switch self {
        case .getTeams:
            return .get
        }
    }
    
    var parameters: Networking.Parameters {
        return .plain
    }
}
