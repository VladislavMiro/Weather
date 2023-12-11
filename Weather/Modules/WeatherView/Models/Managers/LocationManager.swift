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

    //MARK: - Private fields
    
    private let locationManager = CLLocationManager()
    
    //MARK: - Initializers
    
    override init() {
        self.coordinates = .init()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    //MARK: - Public methods
    
    public func getCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
