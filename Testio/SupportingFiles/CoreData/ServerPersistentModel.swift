// This class was created by taking inspiration from https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial and
// https://developer.apple.com/documentation/coredata


import Foundation
import CoreData
import UIKit
import TOLogger

enum CoreDataResult<T> {
    case success(T)
    case error
}

final class ServerPersistentModel {
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
            Logger.logWarning("server.name is nil")
            return
        }
        guard let distance = server.distance else {
            Logger.logWarning("server.distance is nil")
            return
        }
        let managedContext = persistentContainer.viewContext
        
        guard let entity =
        NSEntityDescription.entity(
            forEntityName: CoreDataConstants.serverCache,
            in: managedContext
        ) else {
            return Logger.logWarning("entity is nil")
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
    
    func getServers(completion: (CoreDataResult<[Server]>) -> Void) {
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
            completion(.success(servers))
        } catch {
            completion(.error)
        }
    }
}
