//
//  TeamDetailViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import Combine

class TeamDetailViewModel {
    @Published var upcomingMatches: [MatchItemViewModel] = []
    @Published var previousMatches: [MatchItemViewModel] = []
    var route = PassthroughSubject<TeamDetailCoordinator.Route, Never>()
    var didClose = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    private let matchRepository: MatchRepositoryProtocol
    
    let team: Team
    
    init(team: Team, matchRepository: MatchRepositoryProtocol) {
        self.team = team
        self.matchRepository = matchRepository
    }
    
    func getTeamMatches() {
        matchRepository.getTeamMatches(name: team.name)
            .replaceError(with: .init(upcoming: [], previous: []))
            .sink { [weak self] matches in
                let upcoming = matches.upcoming.map { MatchItemViewModel(item: $0, isPrevious: false) }
                let previous = matches.previous.map { MatchItemViewModel(item: $0, isPrevious: true) }
                
                self?.upcomingMatches = upcoming
                self?.previousMatches = previous
            }
            .store(in: &subscriptions)
    }
}
