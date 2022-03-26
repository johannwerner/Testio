//
//  ServerPersistentModel.swift
//  Testio
//
//  Created by Johann Werner on 26.03.22.
//

import Foundation
import CoreData
import UIKit

class ServerPersistentModel {
    private init() {}
    static var shared = ServerPersistentModel()
    
    var managedObjects: [NSManagedObject] = []

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataConstants.persistentContainerName)
        container.loadPersistentStores(completionHandler: { _, _ in
        })
        return container
    }()
    
    func save(server: Server) {
        guard let name = server.name else {
            return
        }
        guard let distance = server.distance else {
            return
        }

        let managedContext = persistentContainer.viewContext

        guard let entity =
        NSEntityDescription.entity(
            forEntityName: CoreDataConstants.serverCache,
            in: managedContext
        ) else {
            return
        }
        
        let server = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )

        server.setValue(name, forKeyPath: CoreDataConstants.serverName)
        server.setValue(distance, forKeyPath: CoreDataConstants.serverDistance)

        do {
            try managedContext.save()
            managedObjects.append(server)
        } catch {}
    }
    
    func deleteAllServers() {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataConstants.serverCache)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                for managedObject in results {
                    if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                        context.delete(managedObjectData)
                    }
                }
            } catch {}
    }
    
    func getServers(completion: ([Server]) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: CoreDataConstants.serverCache)
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
            var servers: [Server] = []
            for mangedObject in managedObjects {
                let name = mangedObject.value(forKey: CoreDataConstants.serverName) as? String
                let distance = mangedObject.value(forKey: CoreDataConstants.serverDistance) as? Int
                let server = Server(name: name, distance: distance)
                servers.append(server)
            }
            completion(servers)
        } catch {}
    }
}
