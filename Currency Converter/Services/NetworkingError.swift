//
//  NetworkingError.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

enum NetworkingError: Error {
    case missingData
    case decodingFailed(Error)
}
