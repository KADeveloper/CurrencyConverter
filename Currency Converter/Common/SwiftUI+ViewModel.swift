//
//  SwiftUI+ViewModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation

class ViewModel<State,
                ViewAction>: ObservableObject, Identifiable {
    @Published var state: State

    init(state: State) {
        self.state = state
    }

    func handleViewAction(_ action: ViewAction) {
        assertionFailure("Received unhandled action: \(action)")
    }
}
