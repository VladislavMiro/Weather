//
//  NetworkManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation
import Combine

struct NetworkError: Error {
    public var message: String
}

final class NetworkManager {
    
    //MARK: - Private fields
    
    private let apiKey: String
    private var session: URLSession
    private var cancelable = Set<AnyCancellable>()
    
    
    private var baseURL = "https://api.weatherapi.com/v1/forecast.json?key=%@&q=%f,%f&days=7&aqi=no&alerts=no"
    private var locationURL = "https://api.weatherapi.com/v1/search.json?key=%@&q=%@"
    
    public init() {
        self.apiKey = "24425d9dafd74dcbb1503428230512"
        session = .init(configuration: .default)
    }
    
}

extension NetworkManager: NetworkManagerProtocol {
    
    public func requestWeather(lat: Float, lon: Float) -> Future<WeatherResponseProtocol, NetworkError> {
        
        return Future { [unowned self] promise in
            let urlString = String(format: baseURL,
                                   apiKey, lat, lon)
            
            guard let url = URL(string: urlString)
            else {
                return promise(
                    .failure(NetworkError(message: "Bad URL adress"))
                )
            }
            
            session
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: WeatherResponse.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        return promise(.failure(NetworkError(message: error.localizedDescription)))
                    case .finished:
                        break
                    }
                } receiveValue: { data in
                    return promise(.success(data))
                }.store(in: &cancelable)
        }
    }
    
    public func requestLocation(locationName: String) -> Future<[RegionProtocol], NetworkError> {
        
        return Future { [unowned self] promise in
            let urlString = String(format: locationURL, apiKey, locationName)
            
            guard let url = URL(string: urlString) else { return promise(.failure(NetworkError(message: "Bad URL adress") )) }
            
            session
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Region].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(NetworkError(message: error.localizedDescription)))
                    }
                } receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &cancelable)
        }
    }
}
