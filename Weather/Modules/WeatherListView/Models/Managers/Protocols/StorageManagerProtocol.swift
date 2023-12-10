//
//  StorageManagerProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import CoreData

protocol StorageManagerProtocol: AnyObject {
    
    func fetchData(with predicate: NSPredicate?) throws -> [CDCoordinates]
    func appendData(data: RegionProtocol) throws
    func deleteData(data: CDCoordinates) throws
    
}
