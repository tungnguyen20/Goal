//
//  TeamDetailCoordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import AVKit

class TeamDetailCoordinator: Coordinator<Void> {
    let navigationController: UINavigationController
    let team: Team
    
    enum Route {
        case openTeam(team: Team)
    }
    
    init(navigationController: UINavigationController, team: Team) {
        self.navigationController = navigationController
        self.team = team
    }
    
    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = TeamDetailViewModel(
            team: team,
            matchRepository: MatchRepository(
                matchService: MatchService(),
                teamService: TeamService(),
                matchDatabase: MatchDatabase(persistentContainer: PersistenceController.shared.container),
                teamDatabase: TeamDatabase(persistentContainer: PersistenceController.shared.container)
            )
        )
        let vc = TeamDetailViewController(viewModel: viewModel)
        
        viewModel.route
            .sink { [weak self] route in
                guard let self = self else { return }
                switch route {
                case .openTeam(let team):
                    self.openTeam(team: team, navigationController: self.navigationController)
                        .sink(receiveValue: { _ in })
                        .store(in: &self.subscriptions)
                }
            }
            .store(in: &subscriptions)
        
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
