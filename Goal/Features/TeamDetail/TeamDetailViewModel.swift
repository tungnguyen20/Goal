//
//  TeamDetailViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import Combine

class TeamDetailViewModel {
    @Published var matchListObject: MatchListObject = .init(upcoming: [], previous: [])
    var route = PassthroughSubject<MatchesCoordinator.Route, Never>()
    var didClose = PassthroughSubject<Void, Never>()
    private let matchRepository: MatchRepositoryProtocol
    
    let team: Team
    
    init(team: Team, matchRepository: MatchRepositoryProtocol) {
        self.team = team
        self.matchRepository = matchRepository
        
        matchRepository.getTeamMatches(name: team.name)
            .assign(to: &self.$matchListObject)
    }
}
