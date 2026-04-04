//
//  HeaderViewModel.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation
import Combine

final class HeaderViewModel: HeaderViewModelProtocol {
    
    //MARK: - Public fields
    
    private(set) var output: CurrentValueSubject<Output, Never>
    private(set) var data: PassthroughSubject<WeatherResponseProtocol,Never>
    
    //MARK: - Private fields

    private var cancelable = Set<AnyCancellable>()
    
    //MARK: -Initializers
    
    public init() {
        self.data = .init()
        
        self.output = .init(
            .init(regionName: "--",
                  temperature: "0" + Symbols.celciusSymbol.localized,
                  description: "---",
                 icon: "d119"))       
        
        bind()
    }
    
    
    private func bind() {
        data
            .map { [unowned self] data in
                return self.convertData(data: data)
            }
            .sink { [unowned self] data in
                output.send(data)
            }.store(in: &cancelable)
    }
    
    private func convertData(data: WeatherResponseProtocol) -> Output {
        
        let icon = (data.current.isDay ? "d" : "n") + data.current.condition.icon
        
        return .init(
            regionName: data.location.name,
                          
            temperature: String(Int(data.current.temp)) + Symbols.celciusSymbol.localized,
                          
            description: data.current.condition.text,
            
            icon: icon)
    }
}



