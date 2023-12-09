//
//  WeatherViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import Foundation
import Combine

protocol WeatherViewModelProtocol: AnyObject {
    
    typealias Coordinate = WeatherViewDataModels.Coordinates
    
    var isRefreshing: PassthroughSubject<Void,Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var data: PassthroughSubject<WeatherResponseProtocol, Never> { get }
    
    func loadData()
    func didFinish()
}
