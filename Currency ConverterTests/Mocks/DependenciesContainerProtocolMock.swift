//
//  DependenciesContainerProtocolMock.swift
//  Currency ConverterTests
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
@testable import Currency_Converter

final class DependenciesContainerProtocolMock: DependenciesContainerProtocol {
    var networking: Currency_Converter.Networking

    init(networking: Currency_Converter.Networking) {
        self.networking = networking
    }
}
