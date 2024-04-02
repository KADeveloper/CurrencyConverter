//
//  ConverterFeature.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation

enum ConverterFeature {
    typealias ViewModelType = ViewModel<State, ViewAction>

    enum NetworkingState {
        case isLoading
        case loaded
        case error
    }

    struct State {
        let currencies: [CurrencyModel]

        var exchangeRates: ConverterExchangeRatesModel = ConverterExchangeRatesModel(rates: [])
        var amountToExchange: Double = .zero
        var convertedAmount: Double = .zero
        var selectedCurrency: CurrencyModel
        var exchangeCurrency: CurrencyModel

        var networkingState: NetworkingState = .loaded
        var isConvertationDisabled: Bool {
            exchangeRates.rates.isEmpty || networkingState == .isLoading || amountToExchange == .zero
        }
    }

    enum ViewAction {
        case didSelect(currency: CurrencyModel)
        case didChange(amount: Double)
        case retry
        case swapCurrencies
        case convertCurrencies
    }
}
