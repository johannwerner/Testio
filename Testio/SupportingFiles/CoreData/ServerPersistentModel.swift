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
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ServerPersistentModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedObjects: [NSManagedObject] = []
    
    var firstName: String? {
        managedObjects.first?.value(forKeyPath: "name") as? String
    }
    
    func save(server: Server) {
        guard let name = server.name else {
            return
        }
        guard let distance = server.distance else {
            return
        }

        let managedContext = persistentContainer.viewContext

        let entity =
        NSEntityDescription.entity(forEntityName: "Server",
                                   in: managedContext)!
        
        let server = NSManagedObject(entity: entity,
                                     insertInto: managedContext)

        server.setValue(name, forKeyPath: "name")
        server.setValue(distance, forKeyPath: "distance")

        do {
            try managedContext.save()
            managedObjects.append(server)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllServers() {
            let context: NSManagedObjectContext = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Server")
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
        let managedContext =
          persistentContainer.viewContext

        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Server")

        do {
          managedObjects = try managedContext.fetch(fetchRequest)
            var servers: [Server] = []
            for mangedObject in managedObjects {
                let name = mangedObject.value(forKey: "name") as? String
                let distance = mangedObject.value(forKey: "distance") as? Int
                let server = Server(name: name, distance: distance)
                servers.append(server)
            }
            completion(servers)
        } catch {}
      }
}
