//
//  HistoryModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation
import SwiftData

@Model
class HistoryModel: Identifiable {
    let selectedCurrency: String
    let exchangedCurrency: String
    let amount: Double
    let exchangedAmount: Double
    let date: Date

    init(
        selectedCurrency: String,
        amount: Double,
        exchangedCurrency: String,
        exchangedAmount: Double
    ) {
        self.selectedCurrency = selectedCurrency
        self.amount = amount
        self.exchangedCurrency = exchangedCurrency
        self.exchangedAmount = exchangedAmount
        self.date = .now
    }
}
