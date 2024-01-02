//
//  AppCoordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 02/01/2024.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func launch() {
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
    }
    
    func openMatches() {
        window.rootViewController = MatchesViewController()
        window.makeKeyAndVisible()
    }
    
}
