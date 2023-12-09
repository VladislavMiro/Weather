//
//  Condition.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation

struct Condition: ConditionProtocol {
    public var text: String
    public var icon: String
    
    enum CodingKeys: CodingKey {
        case text
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let icon = try container.decode(String.self, forKey: .icon)
        
        self.text = try container.decode(String.self, forKey: .text)
        self.icon = String(icon.dropFirst(icon.count - 7).dropLast(4))
    }
}
