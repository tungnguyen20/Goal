//
//  MatchItemViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 07/01/2024.
//

import Foundation

struct TeamMatchItemViewModel {
    var matchItem: MatchItem
    var date: String?
    var time: String?
    var homeName: String
    var awayName: String
    var homeLogo: String
    var awayLogo: String
    var isHomeWinner: Bool
    var isAwayWinner: Bool
    var highlights: String?
    var isPrevious: Bool
}

extension TeamMatchItemViewModel {
    
    init(item: MatchItem, isPrevious: Bool) {
        self.matchItem = item
        self.isPrevious = isPrevious
        date = item.match.date.toDate(format: .yyyyMMddHHmmssZ)?.toString(format: .ddMM)
        time = item.match.date.toDate(format: .yyyyMMddHHmmssZ)?.toString(format: .hhmm)
        homeName = item.home.name
        awayName = item.away.name
        homeLogo = item.home.logo
        awayLogo = item.away.logo
        isHomeWinner = item.match.winner == item.home.name
        isAwayWinner = item.match.winner == item.away.name
        highlights = item.match.highlights
    }
    
}

extension TeamMatchItemViewModel: Hashable {
    static func == (lhs: TeamMatchItemViewModel, rhs: TeamMatchItemViewModel) -> Bool {
        lhs.matchItem == rhs.matchItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(matchItem)
        hasher.combine(isPrevious)
    }
}
