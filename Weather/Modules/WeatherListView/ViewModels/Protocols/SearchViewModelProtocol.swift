//
//  SearchViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 07.12.2023.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    
    typealias Output = SearchViewOutput
    
    var searchText: PassthroughSubject<String, Never> { get }
    var refreshData: PassthroughSubject<Void, Never> { get }
    var selectionItem: PassthroughSubject<Int, Never> { get }
    var error: PassthroughSubject<String, Never> { get }
    var selectedItem: PassthroughSubject<RegionProtocol, Never> { get }
    
    var output: [Output] { get }
    
}
