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
}

struct MatchListObject {
    var upcoming: [MatchItem]
    var previous: [MatchItem]
}
