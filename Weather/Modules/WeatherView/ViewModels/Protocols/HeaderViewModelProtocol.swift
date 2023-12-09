//
//  HeaderViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 02.12.2023.
//

import Foundation
import Combine

protocol HeaderViewModelProtocol: AnyObject {
    
    typealias Output = WeatherViewDataModels.HeaderOutputData
    
    var output: CurrentValueSubject<Output, Never> { get }
    var data: PassthroughSubject<WeatherResponseProtocol,Never> { get }
    
}
