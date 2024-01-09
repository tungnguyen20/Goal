//
//  TeamFilterItemViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 08/01/2024.
//

import Foundation

class TeamFilterItemViewModel {
    var logo: String
    var name: String
    var isSelecting: Bool
    var team: Team
    
    init(team: Team, isSelecting: Bool) {
        self.logo = team.logo
        self.name = team.name
        self.isSelecting = isSelecting
        self.team = team
    }
    
}

extension TeamFilterItemViewModel: Hashable {
    
    static func == (lhs: TeamFilterItemViewModel, rhs: TeamFilterItemViewModel) -> Bool {
        return lhs.team == rhs.team && lhs.isSelecting == rhs.isSelecting
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(team)
        hasher.combine(isSelecting)
    }
    
}
