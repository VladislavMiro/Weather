//
//  Day.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

struct Day: DayProtocol {
    var avgTempC: Float = 0.0
    var avgTempF: Float = 0.0
    var dailyWillItSnow: Bool = false
    var dailyChanceOfSnow: Int = 0
    var dailyWillItRain: Bool = false
    var dailyChanceOfRain: Int = 0
    var condition: Condition
    var uv: Int = 0
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case avgtempC, avgtempF
        case dailyWillItRain, dailyChanceOfRain
        case dailyWillItSnow, dailyChanceOfSnow
        case condition, uv
    }
    
    init(avgTempC: Float, avgTempF: Float, dailyWillItSnow: Bool, dailyChanceOfSnow: Int,
         dailyWillItRain: Bool, dailyChanceOfRain: Int, condition: Condition, uv: Int) {
        self.avgTempC = avgTempC
        self.avgTempF = avgTempF
        self.dailyWillItSnow = dailyWillItSnow
        self.dailyWillItRain = dailyWillItRain
        self.dailyChanceOfSnow = dailyChanceOfSnow
        self.dailyChanceOfRain = dailyChanceOfRain
        self.uv = uv
        self.condition = condition
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.avgTempC = try data.decode(Float.self, forKey: .avgtempC)
        self.avgTempF = try data.decode(Float.self, forKey: .avgtempF)
        self.condition = try data.decode(Condition.self, forKey: .condition)
        self.uv = try data.decode(Int.self, forKey: .uv)
        self.dailyChanceOfSnow = try data.decode(Int.self, forKey: .dailyChanceOfSnow)
        self.dailyChanceOfRain = try data.decode(Int.self, forKey: .dailyChanceOfRain)
        let isSnow = try data.decode(Int.self, forKey: .dailyWillItSnow)
        let isRain = try data.decode(Int.self, forKey: .dailyWillItRain)
        
        if isRain == 1 {
            dailyWillItRain = true
        } else {
            dailyWillItRain = false
        }
        
        if isSnow == 1 {
            dailyWillItSnow = true
        } else {
            dailyWillItSnow = false
        }
    }
}
