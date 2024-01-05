//
//  Match.swift
//  Goal
//
//  Created by Tung Nguyen on 03/01/2024.
//

import Foundation

struct Match: Decodable {
    var date: String
    var description: String
    var home: String
    var away: String
    var winner: String?
    var highlights: String?
    
    init(entity: MatchEntity) {
        date = entity.date ?? ""
        description = entity.desc ?? ""
        home = entity.home ?? ""
        away = entity.away ?? ""
        winner = entity.winner
        highlights = entity.highlights
    }
}

extension Match: Hashable {}

struct MatchList: Decodable {
    var previous: [Match]
    var upcoming: [Match]
}

struct MatchListResponse: Decodable {
    var matches: MatchList
}
