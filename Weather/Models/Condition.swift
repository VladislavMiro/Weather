//
//  Condition.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Condition: ConditionProtocol {
    var text: String
    var icon: String
    var code: Int
    
    private enum CodingKeys: String, CodingKey {
        case text, icon, code
    }
    
    init(text: String, icon: String, code: Int) {
        self.text = text
        self.icon = icon
        self.code = code
    }
    
    init(from decoder: Decoder) throws {
        let data =  try decoder.container(keyedBy: CodingKeys.self)
        
        text = try data.decode(String.self, forKey: .text)
        code = try data.decode(Int.self, forKey: .code)
        let imagePath = try data.decode(String.self, forKey: .icon)
        icon = imagePath.dropFirst(imagePath.count - 7).dropLast(4).description
    }
}
