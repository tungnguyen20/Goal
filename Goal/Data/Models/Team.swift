//
//  Team.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

struct Team: Decodable {
    var id: String
    var name: String
    var logo: String
    
    init(entity: TeamEntity) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.logo = entity.logo ?? ""
    }
}

extension Team: Hashable {}

struct TeamListResponse: Decodable {
    var teams: [Team]
}

