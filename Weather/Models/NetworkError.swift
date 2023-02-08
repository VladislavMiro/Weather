//
//  NetworkError.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 08.02.2023.
//

import Foundation

struct APINetworkError: Error, Decodable, CustomStringConvertible {
    let code: Int
    let message: String
    var description: String {
        return "Error \(code): " + message
    }
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    private enum ErrorCodingKeys: String, CodingKey {
        case error
    }
    
    private enum CodingKeys: String, CodingKey {
        case code, message
    }

    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: ErrorCodingKeys.self) .nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        
        self.code = try data.decode(Int.self, forKey: .code)
        self.message = try data.decode(String.self, forKey: .message)
    }
}
