//
//  WeekForecastViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

protocol WeekForecastViewModelProtocol {
    
    typealias Output = WeatherViewDataModels.WeekForecastOutputData
    
    var refreshData: PassthroughSubject<Void, Never> { get }
    var output: [Output] { get }
    var data: PassthroughSubject<WeatherResponseProtocol, Never> { get }
    
}
