//
//  AirConditionViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

protocol AirConditionViewModelProtocol {
    
    typealias Output = WeatherViewDataModels.AirConditionOutputData
    
    var output: CurrentValueSubject<Output,Never> { get }
    var data: PassthroughSubject<WeatherResponseProtocol, Never> { get }
    
    func openWeatherDetailView()
    
}
