//
//  WeatherListViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import Combine

final class WeatherListViewModel: WeatherListViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var refreshData: PassthroughSubject<Void, Never>
    private(set) var error: PassthroughSubject<String, Never>
    private(set) var itemIsDeleted: PassthroughSubject<Void, Never>
    private(set) var selectedItem: PassthroughSubject<Int, Never>
    
    private(set) var output: [WeatherListOutput]
    
    //MARK: - Private fields
    
    private let storageManager: StorageManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let coordinator: WeatherListViewCoordinatorProtocol

    private var coordinates: [CDCoordinates]
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(coordinator: WeatherListViewCoordinatorProtocol, storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.storageManager = StorageManager()
        self.networkManager = NetworkManager()
        
        
        self.refreshData = .init()
        self.coordinates = []
        self.selectedItem = .init()
        self.itemIsDeleted = .init()
        self.error = .init()
        
        self.output = []
        
        bind()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        
        selectedItem.sink { [unowned self] index in
            
            let coordinates = self.coordinates[index]
            
            self.coordinator.showWeatherView(coordinates: coordinates, coordinator: coordinator)
            
        }.store(in: &cancelable)

    }
    
    private func requestData(coordinates: CDCoordinates) {
        networkManager
            .requestWeather(lat: coordinates.latitude, lon: coordinates.longitude)
            .sink { [unowned self] completion in
                
                switch completion {
                case .finished:
                    self.refreshData.send()
                case .failure(let error):
                    self.error.send(error.message)
                }
                
            } receiveValue: { [unowned self] data in
                self.output.append(.init(data: data))
            }.store(in: &cancelable)
    }
    
    private func requestFromNetwork() {
        output.removeAll()
        
        coordinates.forEach { coordinates in
            self.requestData(coordinates: coordinates)
        }
    }
    
}

extension WeatherListViewModel {
    
    public func fetchData() {
        do {
            coordinates =  try storageManager.fetchData()
            
            requestFromNetwork()
            
        } catch let error {
            self.error.send(error.localizedDescription)
        }
    }
    
    public func deleteData(at index: Int) -> Bool {
        
        do {
            let coordinate = coordinates[index]
            
            try storageManager.deleteData(data: coordinate)
            
            output.remove(at: index)
            coordinates.remove(at: index)
            
            return true
            
        } catch let error {
            self.error.send(error.localizedDescription)
            return false
        }
                    
    }
}
