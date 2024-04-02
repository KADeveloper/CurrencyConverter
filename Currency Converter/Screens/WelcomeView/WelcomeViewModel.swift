//
//  WelcomeViewModel.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import Foundation
import SwiftData
import Dependencies

@Observable
final class WelcomeViewModel {
    enum ViewAction {
        case viewAppeared(modelContext: ModelContext)
        case retry
    }

    enum State {
        case loading
        case emptyData
        case error
    }

    private let networking: Networking

    private var modelContext: ModelContext?

    var state: State = .error
    var tabBarViewModel: CCTabBarViewModel? = nil

    init() {
        @Dependency(\.di) var di: DependenciesContainerProtocol
        self.networking = di.networking
    }

    func handleViewAction(_ action: ViewAction) {
        switch action {
        case .viewAppeared(let modelContext):
            self.modelContext = modelContext
            fetchCurrencies()

        case .retry:
            fetchCurrencies()
        }
    }

    // MARK: Networking
    private func fetchCurrencies() {
        state = .loading

        Task { @MainActor in
            do {
                let response = try await networking.loadCurrencies()
                try mapCurrencies(response: response)
            } catch {
                if let currencyList = getCurrencyList() {
                    displayTabBar(with: currencyList)
                } else {
                    state = .error
                }
            }
        }
    }

    // MARK: Mapping
    private func mapCurrencies(response: CurrencyListResponse) throws {
        guard response.currenciesInfo.count >= 2 else {
            state = .emptyData
            return
        }

        let currencies = response.currenciesInfo.map {
            CurrencyModel(
                name: $0.name,
                code: $0.code,
                nativeSymbol: $0.symbolNative,
                decimalDigits: $0.decimalDigits
            )
        }

        let currencyList = CurrencyListModel(currencies: currencies)

        save(currencyList: currencyList)
        displayTabBar(with: currencyList)
    }

    // MARK: Navigation
    private func displayTabBar(with currencyList: CurrencyListModel) {
        guard let modelContext else {
            assertionFailure("Unexpected fount nil")
            return
        }

        tabBarViewModel = CCTabBarViewModel(currencyList: currencyList, modelContext: modelContext)
    }

    // MARK: Storage
    private func getCurrencyList() -> CurrencyListModel? {
        let descriptor = FetchDescriptor<CurrencyListModel>()
        return try? modelContext?.fetch(descriptor).last
    }

    private func save(currencyList: CurrencyListModel) {
        modelContext?.insert(currencyList)
        try? modelContext?.save()
    }
}
