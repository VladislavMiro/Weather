//
//  LocationManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import Foundation
import Combine
import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    
    var coordinates: PassthroughSubject<CLLocationCoordinate2D, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    
    func requestAuthStatus()
    func getCurrentLocation()
}
