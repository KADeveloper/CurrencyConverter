//
//  HistoryFeature.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

enum HistoryFeature {
    // Add ViewAction if needed
    // For example user want to be able see convertation details
    typealias ViewModelType = ViewModel<State, Never>

    struct State {
        var convertations: [Bool] = []
    }
}
