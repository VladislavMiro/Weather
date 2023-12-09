//
//  NetworkManagerProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation
import Combine

protocol NetworkManagerProtocol: AnyObject {
    
    func requestWeather(lat: Float, lon: Float) -> Future<WeatherResponseProtocol, NetworkError>
    func requestLocation(locationName: String) -> Future<[RegionProtocol], NetworkError>

}
