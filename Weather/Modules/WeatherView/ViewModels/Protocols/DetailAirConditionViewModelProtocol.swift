//
//  DetailAirConditionViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

protocol DetailAirConditionViewModelProtocol: AnyObject {
    
    var output:  CurrentValueSubject<[DetailAirConditionDataModel.AirConditionCellOutputData], Never> { get }
    var data: CurrentValueSubject<WeatherResponseProtocol, Never> { get }
    
    func finish()
    
}
