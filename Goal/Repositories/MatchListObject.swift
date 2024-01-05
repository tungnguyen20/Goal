//
//  MatchListObject.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation

struct MatchItem: Hashable {
    var match: Match
    var home: Team
    var away: Team
    
    static func == (lhs: MatchItem, rhs: MatchItem) -> Bool {
        lhs.match == rhs.match && lhs.home == rhs.home && lhs.away == rhs.away
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(match)
        hasher.combine(home)
        hasher.combine(away)
    }
}

struct MatchListObject {
    var upcoming: [MatchItem]
    var previous: [MatchItem]
}
