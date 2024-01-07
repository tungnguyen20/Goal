//
//  TeamDatabase.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import Combine
import CoreData

protocol TeamDatabaseProtocol {
    func getAllTeams() -> AnyPublisher<[Team], Error>
    func save(teams: [Team])
}

class TeamDatabase: TeamDatabaseProtocol {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getAllTeams() -> AnyPublisher<[Team], Error> {
        let request: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        return Future<[Team], Error> { promise in
            do {
                let teamEntities = try context.fetch(request)
                let teams = teamEntities.map { Team(entity: $0) }
                promise(.success(teams))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(teams: [Team]) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = TeamEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(deleteRequest)
                teams.forEach { team in
                    let entity = TeamEntity(context: context)
                    entity.id = team.id
                    entity.name = team.name
                    entity.logo = team.logo
                }
                try context.save()
            } catch {
                print("Failed to save teams to core data: \(error)")
            }
        }
    }
}
