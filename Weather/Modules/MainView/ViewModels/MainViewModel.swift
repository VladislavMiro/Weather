//
//  MainViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {

    //MARK: - Public fields
    
    private(set) var selectedTab: CurrentValueSubject<Int, Never>
    
    //MARK: - Private fields
    
    private let coordinator: MainViewCoordinatorProtocol
    
    private var currentTab: Int = -1
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: Initialaizers
    
    public init(coordinator: MainViewCoordinatorProtocol) {
        self.coordinator = coordinator
        
        selectedTab = .init(0)
        
        bind()
    }

    //MARK: Private methods
    
    private func bind() {
        selectedTab.sink { [unowned self] tabIndex in
            if currentTab != tabIndex {
                switch tabIndex {
                case 0:
                    coordinator.openWeatherView()
                    
                case 1:
                    coordinator.openWeatherListView()
                    
                default:
                    break
                }
                
                currentTab = tabIndex
            }
        }.store(in: &cancelable)
        
    }
    
}
