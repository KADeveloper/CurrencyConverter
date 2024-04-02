//
//  HistoryView.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \HistoryModel.date, order: .reverse) private var convertationHistory: [HistoryModel]

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 32) {
                Text("History")
                    .foregroundStyle(Color.ccBlue)
                    .font(.title)
                    .fontWeight(.bold)

                if convertationHistory.isEmpty {
                    Spacer()
                    VStack(alignment: .center, spacing: 8) {
                        Text("Ooops!")

                        Image(.sadIcon)

                        Text("You don't have convertations yet")
                    }
                    Spacer()
                } else {
                    ScrollView {
                        historyListView
                    }
                    .padding(.horizontal)
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
        }
    }

    init(viewModel: HistoryViewModel) {

    }
}

private extension HistoryView {
    var historyListView: some View {
        LazyVStack {
            ForEach(convertationHistory, id: \.id) { convertation in
                VStack {
                    HStack {
                        Text("Converted")
                            .font(.body)

                        Spacer()

                        Text(
                            convertation.date,
                            style: .date
                        )
                    }

                    HStack {
                        Text("from: ")

                        Text(
                            convertation.amount,
                            format: .currency(code: convertation.selectedCurrency)
                        )

                        Spacer()
                    }
                    .font(.headline)
                    .foregroundStyle(.green)

                    HStack {
                        Text("to: ")

                        Text(
                            convertation.exchangedAmount,
                            format: .currency(code: convertation.exchangedCurrency)
                        )

                        Spacer()
                    }
                    .font(.headline)
                    .foregroundStyle(.ccBlue)
                }
                .padding(.horizontal)
                .background(Color.ccGray)
                .contentShape(.capsule)

                if convertation != convertationHistory.last {
                    CCDivider()
                }
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel())
}
