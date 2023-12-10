//
//  LocationManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, LocationManagerProtocol {
    
    //MARK: - Public fields
    
    public let coordinates: PassthroughSubject<CLLocationCoordinate2D, Never>
    public let error: PassthroughSubject<String, Never>
    
    //MARK: - Private fields
    
    private let locationManager = CLLocationManager()
    
    //MARK: - Initializers
    
    override init() {
        self.coordinates = .init()
        self.error = .init()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    //MARK: - Public methods
    
    public func requestAuthStatus() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func getCurrentLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
}

//MARK: - Location Manager delegate

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        defer {
            manager.stopUpdatingLocation()
        }
        
        guard let location = locations.first else { return }
        
        self.coordinates.send(location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error.send(error.localizedDescription)
        manager.stopUpdatingLocation()
    }
}
