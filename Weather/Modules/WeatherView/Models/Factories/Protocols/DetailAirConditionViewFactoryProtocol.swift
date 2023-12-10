//
//  DetailAirConditionViewFactoryProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 06.12.2023.
//

import UIKit

protocol DetailAirConditionViewFactoryProtocol {
    func createDetailAirConditionView(data: WeatherResponseProtocol, coordinator: DetailAirConditionCoordinatorProtocol) -> UIViewController
}
