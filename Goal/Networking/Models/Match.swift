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
}
