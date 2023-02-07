//
//  DayProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

protocol DayProtocol: Decodable {
    var avgTempC: Float { get }
    var avgTempF: Float { get }
    var dailyWillItSnow: Bool { get }
    var dailyChanceOfSnow: Int { get }
    var dailyWillItRain: Bool { get }
    var dailyChanceOfRain: Int { get }
    var condition: Condition { get }
    var uv: Int { get }
}
