//
//  TeamsFilterViewModel.swift
//  Goal
//
//  Created by Tung Nguyen on 08/01/2024.
//

import Foundation
import Combine

class TeamsFilterViewModel {
    var didClose = PassthroughSubject<[Team], Never>()
    @Published var teams: [Team] = []
    @Published var selectingTeams: Set<Team> = []
    @Published var teamItemViewModels: [TeamFilterItemViewModel] = []
    let repository: MatchRepositoryProtocol
    
    init(repository: MatchRepositoryProtocol, selectingTeams: [Team]) {
        self.selectingTeams = Set(selectingTeams)
        self.repository = repository

        Publishers.CombineLatest($teams, $selectingTeams)
            .map { teams, selectedTeams in
                return teams.map { team in
                    return TeamFilterItemViewModel(team: team, isSelecting: selectedTeams.contains(team))
                }
            }
            .assign(to: &self.$teamItemViewModels)
    }
    
    func getAllTeams() {
        repository.getAllTeams()
            .replaceError(with: [])
            .assign(to: &self.$teams)
    }

    func toggleItem(item: TeamFilterItemViewModel) {
        if selectingTeams.contains(item.team) {
            selectingTeams.remove(item.team)
        } else {
            selectingTeams.insert(item.team)            
        }
    }
    
}
