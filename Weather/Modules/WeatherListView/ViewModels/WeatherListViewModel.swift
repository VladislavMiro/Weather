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
    private(set) var selectedItem: PassthroughSubject<Int, Never>
    private(set) var output: [WeatherListOutput]
    
    //MARK: - Private fields
    
    private let storageManager: StorageManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let coordinator: WeatherListViewCoordinatorProtocol

    private var coordinates: CurrentValueSubject<[CDCoordinates], Never>
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(coordinator: WeatherListViewCoordinatorProtocol, storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.coordinator = coordinator
        self.storageManager = StorageManager()
        self.networkManager = NetworkManager()
        
        
        self.refreshData = .init()
        self.coordinates = .init([])
        self.selectedItem = .init()
        
        self.output = []
        
        bind()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        coordinates
            .sink { [unowned self] coordinates in
                coordinates.forEach { coordinate in
                    self.requestData(coordinates: coordinate)
                }
            }.store(in: &cancelable)
        
        selectedItem.sink { [unowned self] index in
            let coordinates = self.coordinates.value[index]
            self.coordinator.showWeatherView(coordinates: coordinates, coordinator: coordinator)
        }.store(in: &cancelable)

    }
    
    private func requestData(coordinates: CDCoordinates) {
        networkManager
            .requestWeather(lat: coordinates.latitude, lon: coordinates.longitude)
            .map({ data -> WeatherListOutput in
                return .init(data: data)
            })
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    refreshData.send()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] data in
                self.output.append(data)
            }.store(in: &cancelable)
    }
}

extension WeatherListViewModel {
    
    public func fetchData() {
        output.removeAll()
        coordinates.value.removeAll()
        refreshData.send()
        
        do {
            let coord =  try storageManager.fetchData()
            
            coordinates.send(coord)
            
        } catch let error {
            //print(error)
        }
    }
    
    public func deleteData(at index: Int) {
        do {
            let coordinate = coordinates.value[index]
            
            try storageManager.deleteData(data: coordinate)
            
            refreshData.send()
        } catch let error {
            print(error)
        }
                    
    }
}
