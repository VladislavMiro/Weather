//
//  MainViewModelProtocol.swift
//  AstonWeather
//
//  Created by Vladislav Miroshnichenko on 01.12.2023.
//

import Foundation
import Combine

protocol MainViewModelProtocol: AnyObject {
    
    var selectedTab: CurrentValueSubject<Int, Never> { get }
    
}
