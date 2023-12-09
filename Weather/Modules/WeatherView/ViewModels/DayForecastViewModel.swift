//
//  DayForecastViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 04.12.2023.
//

import Foundation
import Combine

final class DayForecastViewModel: DayForecastViewModelProtocol {
    
    
    //MARK: - Public fields
    
    private(set) var refreshData: PassthroughSubject<Void, Never>
    private(set) var data = PassthroughSubject<WeatherResponseProtocol, Never>()
    private(set) var output: [Output]
    
    //MARK: - Private fields
    
    private var cancelable = Set<AnyCancellable>()
    
    //MARK: - Initialaizers
    
    public init() {
        self.output = []
        self.refreshData = .init()
        
        bind()
    }
    
    //MARK: - Private methods
    
    private func bind() {
        data.map({ [unowned self] data in
            return self.convertData(data: data.forecast.first?.hour ?? [])
        })
        .sink { [unowned self] data in
            self.output = data
            self.refreshData.send()
        }.store(in: &cancelable)
    }
    
    private func convertData(data: [DailyForecastProtocol]) -> [Output] {
        
        let array = data.map { data -> Output in
            
            let icon = (data.isDay ? "d" : "n") + data.condition.icon
 
            return .init(
                time: convertDate(date: data.time) ?? "00:00",
                temperature: String(Int(data.temp)) + Resources.Symbols.celciusSymbol,
                icon: icon)
        }
        
        return array
    }
    
    private func convertDate(date: String) -> String? {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: date) else { return nil }
        
        formatter.dateFormat = "HH:mm"
       
        return formatter.string(from: date)
    }
    
}
