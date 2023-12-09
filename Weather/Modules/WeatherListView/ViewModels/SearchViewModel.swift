//
//  SearchViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import Foundation
import Combine

final class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var searchText: PassthroughSubject<String, Never>
    private(set) var refreshData: PassthroughSubject<Void, Never>
    private(set) var selectionItem: PassthroughSubject<Int, Never>
    private(set) var error: PassthroughSubject<String, Never>
    private(set) var selectedItem: PassthroughSubject<RegionProtocol, Never>
    
    private(set) var output: [Output]
    
    //MARK: - Private fields
    
    private let networkManager: NetworkManagerProtocol
    private let storageManager: StorageManagerProtocol
    
    private var data: [RegionProtocol]
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.storageManager = storageManager
        self.networkManager = networkManager 
        self.data = []
        self.output = []
        
        searchText = .init()
        refreshData = .init()
        selectionItem = .init()
        selectedItem = .init()
        error = .init()
        
        bind()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        searchText.sink { [unowned self] searchText in
            if searchText.isEmpty {
                output.removeAll()
                refreshData.send()
                return
            }
            
            self.searchLocation(searchText: searchText)
        }.store(in: &cancelable)
        
        selectionItem.sink { [unowned self] index in
            self.saveData(data: data[index])
        }.store(in: &cancelable)
    }
    
    private func searchLocation(searchText: String) {
        self.networkManager
            .requestLocation(locationName: searchText)
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink { [unowned self] data in
                self.data = data
                self.output = self.prepareData(data: data)
                self.refreshData.send()
            }.store(in: &cancelable)
    }
    
    private func prepareData(data: [RegionProtocol]) -> [Output] {
        return data.map { data -> Output in
            return .init(data: data)
        }
    }
    
    private func saveData(data: RegionProtocol) {
        let entity = storageManager.createEntity()
        
        entity.latitude = data.lat
        entity.longitude = data.lon
        
        do {
            try storageManager.appendData(data: entity)
            
            selectedItem.send(data)
        } catch let error {
            self.error.send(error.localizedDescription)
        }
        
    }
    
}
