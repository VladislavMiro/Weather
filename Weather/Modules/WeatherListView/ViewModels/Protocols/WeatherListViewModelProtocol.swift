//
//  WeatherListViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 08.12.2023.
//

import Foundation
import Combine

protocol WeatherListViewModelProtocol: AnyObject {
    
    var refreshData: PassthroughSubject<Void, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var selectedItem: PassthroughSubject<Int, Never> { get }
    var output: [WeatherListOutput] { get }
    
    func fetchData()
    func deleteData(at index: Int) -> Bool
    func didFinish()
    
}
