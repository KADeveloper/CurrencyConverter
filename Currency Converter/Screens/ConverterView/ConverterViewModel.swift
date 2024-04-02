//
//  ConverterViewModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
import Dependencies
import SwiftData

final class ConverterViewModel: ConverterFeature.ViewModelType {
    private let networking: Networking
    private let modelContext: ModelContext

    init(
        currencyList: CurrencyListModel,
        modelContext: ModelContext
    ) {
        @Dependency(\.di) var di: DependenciesContainerProtocol
        networking = di.networking

        self.modelContext = modelContext

        let currencies = currencyList.currencies.sorted(by: { $0.code < $1.code })

        super.init(
            state: .init(
                currencies: currencies,
                selectedCurrency: currencies.first!,
                exchangeCurrency: currencies.last!
            )
        )

        loadExchangeRates()
    }

    override func handleViewAction(_ action: ConverterFeature.ViewAction) {
        switch action {
        case .didSelect(let currency):
            state.selectedCurrency = currency

        case .didChange(let amount):
            state.amountToExchange = amount
            updateAmountToExchange()

        case .retry:
            loadExchangeRates()

        case .swapCurrencies:
            swapCurrencies()

        case .convertCurrencies:
            convertCurrencies()
        }
    }

    // MARK: Networking
    private func loadExchangeRates() {
        state.networkingState = .isLoading

        Task { @MainActor in
            do {
                let count: Int

                if state.currencies.count % 2 == .zero {
                    count = state.currencies.count / 2
                } else {
                    count = state.currencies.count / 2 + 1
                }

                var exchangeRates = [CurrencyExchangeDataResponse]()
                for currency in state.currencies.prefix(count) {
                    let response = try await self.loadExchangeRate(for: currency)
                    exchangeRates.append(response)
                }

                state.exchangeRates = ConverterExchangeRatesModel(
                    rates: exchangeRates.map { ConverterExchangeRateModel(rates: $0.data) }
                )
                state.networkingState = .loaded
                updateAmountToExchange()
                saveExchangeRates(exchangeRates)
            } catch {
                if let exchangeRates = getConvertedExchangeRatesModel() {
                    state.exchangeRates = exchangeRates
                } else {
                    state.networkingState = .error
                }
            }
        }
    }

    private func loadExchangeRate(for currency: CurrencyModel) async throws -> CurrencyExchangeDataResponse {
        try await networking.loadExchangeRate(for: currency.code)
    }

    private func swapCurrencies() {
        (state.selectedCurrency, state.exchangeCurrency) = (state.exchangeCurrency, state.selectedCurrency)
        (state.amountToExchange, state.convertedAmount) = (state.convertedAmount, state.amountToExchange)
    }

    private func convertCurrencies() {
        let historyModel = HistoryModel(
            selectedCurrency: state.selectedCurrency.code,
            amount: state.amountToExchange,
            exchangedCurrency: state.exchangeCurrency.code,
            exchangedAmount: state.convertedAmount
        )

        modelContext.insert(historyModel)
        try? modelContext.save()
    }

    private func mapExchangeRates(response: CurrencyExchangeDataResponse) {
        guard let selectedRate = response.data[state.selectedCurrency.code],
              let exchangeRate = response.data[state.exchangeCurrency.code] else { return }

        if selectedRate == 1 {
            state.convertedAmount = state.amountToExchange * selectedRate
        } else if exchangeRate == 1 {
            state.convertedAmount = state.amountToExchange / selectedRate
        }
    }

    private func updateAmountToExchange() {
        guard let exchangeRate = state.exchangeRates.rates.first(
            where: { $0.rates[state.selectedCurrency.code] == 1 || $0.rates[state.exchangeCurrency.code] == 1 }
        ) else { return }

        if exchangeRate.rates[state.selectedCurrency.code] == 1 {
            state.convertedAmount = state.amountToExchange * (exchangeRate.rates[state.exchangeCurrency.code] ?? 0)
        } else {
            state.convertedAmount = state.amountToExchange / (exchangeRate.rates[state.selectedCurrency.code] ?? 1)
        }
    }

    // MARK: Storage
    private func getConvertedExchangeRatesModel() -> ConverterExchangeRatesModel? {
        let fetchDescriptor = FetchDescriptor<CurrencyExchangeRatesModel>()
        guard let persistedModel = try? modelContext.fetch(fetchDescriptor).last else { return nil }

        return ConverterExchangeRatesModel(
            rates: persistedModel.rates.map { ConverterExchangeRateModel(rates: $0.rate) }
        )
    }

    private func saveExchangeRates(_ exchangeRates: [CurrencyExchangeDataResponse]) {
        let exchangeRates = exchangeRates.map {
            CurrencyExchangeRateModel(rate: $0.data)
        }
        let exchangeRatesModel = CurrencyExchangeRatesModel(rates: exchangeRates)
        modelContext.insert(exchangeRatesModel)
        try? modelContext.save()
    }
}
