//
//  WeatherViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import Foundation
import Combine

final class WeatherViewModel: WeatherViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var isRefreshing: PassthroughSubject<Void,Never>
    private(set) var error: PassthroughSubject<String, Never>
    private(set) var data: PassthroughSubject<WeatherResponseProtocol, Never> = .init()
    
    //MARK: - Private fields
    
    private let networkManager: NetworkManagerProtocol
    private let locationManager: LocationManagerProtocol?
    private let coordinator: WeatherViewCoordinatorProtocol
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initializers
    
    public init(coordinator: WeatherViewCoordinatorProtocol, networkManager: NetworkManagerProtocol, locationManager: LocationManagerProtocol? = nil) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.coordinator = coordinator
        
        self.error = .init()
        self.isRefreshing = .init()
        
        bind()
    }
    
    convenience init(coordinator: WeatherViewCoordinatorProtocol, networkManager: NetworkManagerProtocol, data: WeatherResponseProtocol) {
        self.init(coordinator: coordinator, networkManager: networkManager)
        self.data.send(data)
    }
    
    //MARK: - Public Methods
    
    public func loadData() {
        if let locationManager = locationManager {
            locationManager.requestAuthStatus()
            locationManager.getCurrentLocation()
        }
    }
    
    public func didFinish() {
        coordinator.finish()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        if let locationManager = locationManager {
            locationManager
                .coordinates.map({ coordinates -> Coordinate in
                    let latitude = Float(coordinates.latitude)
                    let longitude = Float(coordinates.longitude)
    
                    return Coordinate(lat: latitude, lon: longitude)
                }).sink { [unowned self] coordinates in
                    
                    self.requestWeather(coordinates: coordinates)
                    
                }.store(in: &cancelable)

            locationManager.error.sink {  [unowned self] error in
                self.error.send(error)
            }.store(in: &cancelable)
        }
    }
    
    private func requestWeather(coordinates: Coordinate) {
        networkManager
            .requestWeather(lat: coordinates.lat, lon: coordinates.lon)
            .sink { [unowned self] error in
                switch error {
                case .finished:
                    break
                case .failure(let error):
                    self.error.send(error.message)
                    self.isRefreshing.send()
                }
            } receiveValue: { [unowned self] data in
                
                self.data.send(data)
                self.isRefreshing.send()
               
            }.store(in: &cancelable)
    }
}
