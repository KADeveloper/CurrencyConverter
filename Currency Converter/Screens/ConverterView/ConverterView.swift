//
//  ConverterView.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import SwiftUI

struct ConverterView: View {
    @StateObject private var viewModel: ConverterFeature.ViewModelType
    @FocusState private var isFocused: Bool

    private var currencySelectionHandler: Binding<CurrencyModel> {
        Binding(
            get: { viewModel.state.selectedCurrency },
            set: { newCurrency in
                viewModel.handleViewAction(.didSelect(currency: newCurrency))
            }
        )
    }

    private var amountValueHandler: Binding<String> {
        Binding(
            get: { String(format: "%.\(viewModel.state.selectedCurrency.decimalDigits)f",
                          viewModel.state.amountToExchange) },
            set: { textOutput in
                guard let amount = Double(textOutput) else { return }
                viewModel.handleViewAction(.didChange(amount: amount))
            }
        )
    }

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 32) {
                Text("Converter")
                    .foregroundStyle(Color.ccBlue)
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    VStack(alignment: .center) {
                        CurrencyPickerView(
                            title: "Select currency",
                            selection: $viewModel.state.selectedCurrency,
                            currencies: viewModel.state.currencies
                        )
                        .tint(.green)

                        TextField("", text: amountValueHandler)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                            .border(.ccBlue, width: 1)
                            .frame(idealWidth: 40, maxWidth: 120)
                    }
                    .fixedSize()

                    Spacer()

                    Button(
                        action: { viewModel.handleViewAction(.swapCurrencies) },
                        label: {
                            Image(.converterIcon)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    )

                    Spacer()

                    VStack {
                        CurrencyPickerView(
                            title: "Exchange currency",
                            selection: $viewModel.state.exchangeCurrency,
                            currencies: viewModel.state.currencies
                        )
                        .tint(.red)

                        Text(viewModel.state.convertedAmount,
                             format: .currency(code: viewModel.state.exchangeCurrency.code))
                    }
                }

                if !viewModel.state.exchangeRates.rates.isEmpty {
                    HStack {
                        Text("Rates downloaded date:")
                        Text(viewModel.state.exchangeRates.date, style: .date)
                    }
                }

                Spacer()

                if viewModel.state.networkingState == .error {
                    VStack(spacing: 8) {
                        Text("Opps, couldn't fetch actual exchange rates")

                        Button(
                            action: { viewModel.handleViewAction(.retry) },
                            label: {
                                Text("Try again")
                            }
                        )
                        .buttonStyle(.ccPrimary)
                    }
                }

                Spacer()

                Button(
                    action: { viewModel.handleViewAction(.convertCurrencies) },
                    label: {
                        if viewModel.state.networkingState == .isLoading {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.2)
                        } else {
                            Text("Convert")
                        }
                    }
                )
                .buttonStyle(.ccPrimary)
                .padding(.bottom, 40)
                .disabled(viewModel.state.isConvertationDisabled)
            }
            .padding(.horizontal)
            .contentShape(.rect)
            .onTapGesture {
                isFocused = false
            }
        }
    }

    init(viewModel: ConverterFeature.ViewModelType) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
