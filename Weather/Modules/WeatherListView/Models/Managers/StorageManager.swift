//
//  StorageManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import CoreData

final class StorageManager {
    
    //MARK: - Private fields
    
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
    
    //MARK: - Private methods

    private func saveContext () throws {
        
        if context.hasChanges {
            try context.save()
        }
    }
    
}

//MARK: - StorageManagerProtocol implementation

extension StorageManager: StorageManagerProtocol {
    
    public func fetchData(with predicate: NSPredicate? = nil) throws -> [CDCoordinates] {
        
        let fetchRequest: NSFetchRequest<CDCoordinates> = NSFetchRequest<CDCoordinates>(entityName: "CDCoordinates")
        
        fetchRequest.predicate = predicate
        
        var values = [CDCoordinates]()
        
        values = try context.fetch(fetchRequest)
        
        return values
    }
    
    public func appendData(data: RegionProtocol) throws {
        
        let predicate = NSPredicate.init(format: "latitude == %f AND longitude == %f ", data.lat, data.lon)
       
        let isEmptyResult = try fetchData(with: predicate).isEmpty
        
        if isEmptyResult {
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: "CDCoordinates", into: context) as! CDCoordinates
            
            entity.latitude = data.lat
            entity.longitude = data.lon
            entity.uuid = UUID()
            
            try saveContext()
        } else {
            context.rollback()
        }
        
    }
    
    public func deleteData(data: CDCoordinates) throws {
        context.delete(data)
        try saveContext()
    }
    
    
}
