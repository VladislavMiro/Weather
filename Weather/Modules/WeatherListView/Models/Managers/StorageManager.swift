//
//  StorageManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import CoreData

final class StorageManager {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private func saveContext () throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension StorageManager: StorageManagerProtocol {

    public func createEntity() -> CDCoordinates {
        return CDCoordinates(context: context)

    }
    
    public func fetchData() throws -> [CDCoordinates] {
        
        let fetchRequest: NSFetchRequest<CDCoordinates> = NSFetchRequest<CDCoordinates>(entityName: "CDCoordinates")
        var values = [CDCoordinates]()
        
        values = try context.fetch(fetchRequest)
        
        return values
    }
    
    public func appendData(data: CDCoordinates) throws {
        context.insert(data)
        try saveContext()
    }
    
    public func deleteData(data: CDCoordinates) throws {
        context.delete(data)
        try saveContext()
    }
    
    
}
