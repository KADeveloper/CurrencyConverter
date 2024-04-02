//
//  Currency_ConverterApp.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import SwiftUI
import SwiftData
import XCTestDynamicOverlay

@main
struct Currency_ConverterApp: App {
    @Environment(\.modelContext) private var modelContext

    private let welcomeViewModel = WelcomeViewModel()

    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                NavigationStack {
                    WelcomeView(viewModel: welcomeViewModel)
                }
                .modelContainer(
                    for: [
                        HistoryModel.self,
                        CurrencyListModel.self,
                        CurrencyExchangeRatesModel.self
                    ]
                )
            }
        }
    }
}
