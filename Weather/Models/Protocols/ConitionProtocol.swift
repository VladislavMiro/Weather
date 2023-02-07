//
//  ConitionProtocol.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import Foundation

protocol ConditionProtocol: Decodable {
    var text: String { get }
    var icon: String { get }
    var code: Int { get }
}
