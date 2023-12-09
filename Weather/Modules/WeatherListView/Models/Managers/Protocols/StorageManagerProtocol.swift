//
//  StorageManagerProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import CoreData

protocol StorageManagerProtocol: AnyObject {
    
    func createEntity() -> CDCoordinates
    func fetchData() throws -> [CDCoordinates]
    func appendData(data: CDCoordinates) throws
    func deleteData(data: CDCoordinates) throws
    
}
