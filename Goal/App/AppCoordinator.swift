//
//  AppCoordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 02/01/2024.
//

import UIKit
import Combine

class AppCoordinator: Coordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func launch() {
        let coordinator = MatchesCoordinator(window: window)
        coordinate(to: coordinator)
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
}
