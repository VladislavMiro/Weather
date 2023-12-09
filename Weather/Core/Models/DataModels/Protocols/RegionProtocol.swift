//
//  RegionProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

protocol RegionProtocol: Decodable {
    var name: String { get }
    var country: String { get }
    var region: String { get }
    var lat: Float { get }
    var lon: Float { get }
}
