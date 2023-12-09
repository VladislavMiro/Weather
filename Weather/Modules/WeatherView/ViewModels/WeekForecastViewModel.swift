//
//  WeekForecastViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 05.12.2023.
//

import Foundation
import Combine

final class WeekForecastViewModel: WeekForecastViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var refreshData: PassthroughSubject<Void, Never>
    private(set) var data: PassthroughSubject<WeatherResponseProtocol, Never>
    private(set) var output: [Output]
    
    //MARK: - Private fields
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: -Initializers
    
    public init () {
        self.output = []
        self.data = .init()
        self.refreshData = .init()
        
        bind()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        data.map({ [unowned self] data -> [Output] in
            return self.prepareData(data: data.forecast)
        }) .sink { [unowned self] data in
            self.output = data
            self.refreshData.send()
        }.store(in: &cancelable)
    }
    
    private func prepareData(data: [ForecastProtocol]) -> [Output] {
        
        return .init(data.map({ data -> Output in
            
            let icon = "d" + data.day.condition.icon
            let temp = String(Int(data.day.minTemp)) + "/" + String(Int(data.day.maxTemp))
            
            return .init(day: formateDay(day: data.date) ?? "---",
                         icon: icon,
                         condition: data.day.condition.text,
                         temperature: temp)
            
        }))
    }
    
    private func formateDay(day: String) -> String? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: day)
        
        guard let date = date else { return nil }
        
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
}
