//
//  Location.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Location: LocationProtocol {
    var id: Int = 0
    var name: String
    var region: String
    var country: String
    var lat: Float
    var lon: Float
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, region, country, lat, lon
    }
    
    init(id: Int = 0, name: String, region: String, country: String, latitude: Float, longitude: Float) {
        self.id = id
        self.name = name
        self.region = region
        self.country = country
        self.lat = latitude
        self.lon = longitude
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? data.decode(Int.self, forKey: .id) {
            self.id = id
        } else {
            self.id = 0
        }
        
        self.name = try data.decode(String.self, forKey: .name)
        self.region = try data.decode(String.self, forKey: .region)
        self.country = try data.decode(String.self, forKey: .country)
        self.lat = try data.decode(Float.self, forKey: .lat)
        self.lon = try data.decode(Float.self, forKey: .lon)
        
    }
}
