//
//  Region.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

struct Region: RegionProtocol {
    public var name: String
    public var region: String
    public var country: String
    public var lat: Float
    public var lon: Float
}
