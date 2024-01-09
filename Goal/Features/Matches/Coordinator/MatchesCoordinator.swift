//
//  MatchesCoordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import UIKit
import Combine
import AVFoundation
import AVKit

class MatchesCoordinator: Coordinator<Void> {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    enum Route {
        case openTeam(team: Team)
        case filter(teams: [Team])
    }
    
    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = MatchesViewModel(
            matchRepository: MatchRepository(
                service: ApiService(),
                matchDatabase: MatchDatabase(persistentContainer: PersistenceController.shared.container),
                teamDatabase: TeamDatabase(persistentContainer: PersistenceController.shared.container)
            )
        )
        let vc = MatchesViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: vc)
        
        viewModel.route
            .sink { [weak self] route in
                guard let self = self else { return }
                switch route {
                case .openTeam(let team):
                    self.openTeam(team: team, navigationController: navigation)
                        .sink(receiveValue: { _ in })
                        .store(in: &self.subscriptions)
                case .filter(let teams):
                    self.openFilter(selectingTeams: teams, navigationController: navigation)
                        .sink(receiveValue: { teams in
                            viewModel.onFilterTeamsChanged(teams: teams)
                        })
                        .store(in: &self.subscriptions)
                }
            }
            .store(in: &subscriptions)
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
    
    func openFilter(selectingTeams: [Team], navigationController: UINavigationController) -> AnyPublisher<[Team], Never> {
        let coordinator = TeamsFilterCoordinator(navigationController: navigationController, selectedTeams: selectingTeams)
        return coordinate(to: coordinator)
    }
    
    func openTeam(team: Team, navigationController: UINavigationController) -> AnyPublisher<Void, Never> {
        let coordinator = TeamDetailCoordinator(navigationController: navigationController, team: team)
        return coordinate(to: coordinator)
    }
}
