//
//  WeathertListViewFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import UIKit

final class WeatherListViewFactory {
    
    //MARK: - Private fields
    
    let networkManager: NetworkManagerProtocol
    let storageManager: StorageManagerProtocol
    
    //MARK: - Initialaizers
    
    public init() {
        self.networkManager = NetworkManager()
        self.storageManager = StorageManager()
    }
    
}

extension WeatherListViewFactory: WeatherListViewFactoryProtocol {
    
    public func createWeatherListView(coordinator: WeatherListViewCoordinatorProtocol) -> UIViewController {
        let searchViewModel = SearchViewModel(storageManager: storageManager, networkManager: networkManager)
        let searchView = SearchView(viewModel: searchViewModel)
        let viewModel = WeatherListViewModel(coordinator: coordinator, storageManager: storageManager, networkManager: networkManager)
        
        return WeatherListView(searchView: searchView, viewModel: viewModel)
    }
    
}
