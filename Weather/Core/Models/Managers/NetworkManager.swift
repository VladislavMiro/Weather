//
//  NetworkManager.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 03.12.2023.
//

import Foundation
import Combine

final class NetworkManager {
    
    //MARK: - Private fields
    
    private let apiKey: String
    private let session: URLSession
    
    private var cancelable = Set<AnyCancellable>()
    
    public init() {
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as! String
        session = .init(configuration: .default)
    }
    
}

extension NetworkManager: NetworkManagerProtocol {
    
    public func requestWeather(lat: Float, lon: Float) -> Future<WeatherResponseProtocol, NetworkError> {
        
        return Future { [unowned self] promise in
            let urlString = String(format: URLPaths.baseURL.rawValue,
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
            let urlString = String(
                format: URLPaths.locationURL.rawValue, apiKey, locationName)
            
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

//MARK: - URL enum

extension NetworkManager {
    
    fileprivate enum URLPaths: String {
        case baseURL = "https://api.weatherapi.com/v1/forecast.json?key=%@&q=%f,%f&days=7&aqi=no&alerts=no"
        case locationURL = "https://api.weatherapi.com/v1/search.json?key=%@&q=%@"
    }
    
}
