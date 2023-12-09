//
//  SearchViewOutput.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation

struct SearchViewOutput {
    let name: String
    let country: String
    
    init(name: String, country: String) {
        self.name = name
        self.country = country
    }
    
    init(data: RegionProtocol) {
        self.name = data.name + ", " + data.region
        self.country = data.country
    }
}
