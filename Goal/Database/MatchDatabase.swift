//
//  MatchDatabase.swift
//  Goal
//
//  Created by Tung Nguyen on 05/01/2024.
//

import Foundation
import Combine
import CoreData

protocol MatchDatabaseProtocol {
    func getAllMatches() -> AnyPublisher<[Match], Error>
    func save(matches: [Match])
}

class MatchDatabase: MatchDatabaseProtocol {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getAllMatches() -> AnyPublisher<[Match], Error> {
        let request: NSFetchRequest<MatchEntity> = MatchEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        return Future<[Match], Error> { promise in
            do {
                let matchEntities = try context.fetch(request)
                let matches = matchEntities.map { Match(entity: $0) }
                promise(.success(matches))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(matches: [Match]) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = MatchEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(deleteRequest)
                
                matches.forEach { match in
                    let entity = MatchEntity(context: context)
                    entity.away = match.away
                    entity.home = match.home
                    entity.winner = match.winner
                    entity.desc = match.description
                    entity.date = match.date
                }
                try context.save()
            } catch {
                print("Failed to save matches to core data: \(error)")
            }
        }
    }
}
