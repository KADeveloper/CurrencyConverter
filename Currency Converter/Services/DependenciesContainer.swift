//
//  DependenciesContainer.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Dependencies

protocol DependenciesContainerProtocol: AnyObject {
    var networking: Networking { get }
}

final class DependenciesContainer: DependenciesContainerProtocol {
    private(set) lazy var networking: Networking = HTTPClient()
}

extension DependenciesContainer: DependencyKey {
    static let liveValue: DependenciesContainerProtocol = DependenciesContainer()
}

extension DependencyValues {
    var di: DependenciesContainerProtocol {
        get { self[DependenciesContainer.self] }
        set { self[DependenciesContainer.self] = newValue }
    }
}
