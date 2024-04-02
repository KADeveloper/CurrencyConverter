//
//  CCTabBarViewModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import Foundation
import SwiftData

@Observable
final class CCTabBarViewModel {
    enum TabItem: Int, CaseIterable, Identifiable {
        case converter = 0
        case history

        var id: Int { rawValue }
    }

    let tabs: [TabItem] = TabItem.allCases
    let converterViewModel: ConverterViewModel
    let historyViewModel = HistoryViewModel()

    var selectedTab: TabItem = .converter

    init(currencyList: CurrencyListModel,
         modelContext: ModelContext) {
        converterViewModel = ConverterViewModel(
            currencyList: currencyList,
            modelContext: modelContext
        )
    }
}
