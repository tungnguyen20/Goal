//
//  Coordinator.swift
//  Goal
//
//  Created by Tung Nguyen on 02/01/2024.
//

import Foundation
import Combine

class Coordinator<ResultType>: NSObject {
    var subscriptions = Set<AnyCancellable>()
    let identifier = UUID()
    var childCoordinators = [UUID: Any]()
    
    func start() -> AnyPublisher<ResultType, Never> {
        fatalError("start() method must be implemented")
    }
    
    private func store<T>(_ coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(_ coordinator: Coordinator<T>) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
    
    @discardableResult
    func coordinate<T>(to coordinator: Coordinator<T>) -> AnyPublisher<T, Never> {
        store(coordinator)
        return coordinator.start()
            .prefix(1)
            .handleEvents(receiveOutput: { _ in
                self.free(coordinator)
            })
            .eraseToAnyPublisher()
    }
}
