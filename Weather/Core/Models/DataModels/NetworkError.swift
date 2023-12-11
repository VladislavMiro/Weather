//
//  NetworkError.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 11.12.2023.
//

import Foundation

struct NetworkError: LocalizedError {
    public var message: String
    
    var errorDescription: String? {
        return message
    }
}
