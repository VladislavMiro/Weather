//
//  DetailAirConditionViewFactory.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

final class DetailAirConditionViewFactory {
    
}

//MARK: - DetailAirConditionViewFactoryProtocol implementation

extension DetailAirConditionViewFactory: DetailAirConditionViewFactoryProtocol {
    
    public func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController {
        
        let headerViewModel = HeaderViewModel()
        let viewModel = DetailAirConditionViewModel(data: data, coordinator: coordinator)
        let header = HeaderView(viewModel: headerViewModel)
        let view = DetailAirConditionView(viewModel: viewModel, header: header)
        
        return view
    }
    
}
