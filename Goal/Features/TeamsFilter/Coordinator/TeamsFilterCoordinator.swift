//
//  TeamsFilterCoordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 08/01/2024.
//

import UIKit
import Combine

class TeamsFilterCoordinator: Coordinator<[Team]> {
    
    let navigationController: UINavigationController
    let selectedTeams: [Team]
    
    init(navigationController: UINavigationController, selectedTeams: [Team]) {
        self.navigationController = navigationController
        self.selectedTeams = selectedTeams
    }
    
    override func start() -> AnyPublisher<[Team], Never> {
        let viewModel = TeamsFilterViewModel(
            repository: MatchRepository(
                service: ApiService(),
                matchDatabase: MatchDatabase(persistentContainer: PersistenceController.shared.container),
                teamDatabase: TeamDatabase(persistentContainer: PersistenceController.shared.container)
            ),
            selectingTeams: selectedTeams
        )
        let vc = TeamsFilterViewController(viewModel: viewModel)
        
        navigationController.pushViewController(vc, animated: true)
        
        return viewModel.didClose
            .prefix(1)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .eraseToAnyPublisher()
    }
    
    func openTeam(team: Team, navigationController: UINavigationController) -> AnyPublisher<Void, Never> {
        let coordinator = TeamDetailCoordinator(navigationController: navigationController, team: team)
        return coordinate(to: coordinator)
    }
    
}
