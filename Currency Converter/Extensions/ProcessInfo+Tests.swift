//
//  ProcessInfo+Tests.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/2/24.
//

import Foundation

extension ProcessInfo {
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
