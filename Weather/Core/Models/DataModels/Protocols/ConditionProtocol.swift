//
//  ConditionProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

protocol ConditionProtocol: Decodable {
    var text: String { get }
    var icon: String { get }
}
