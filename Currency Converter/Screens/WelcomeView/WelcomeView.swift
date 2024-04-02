//
//  WelcomeView.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @State private var viewModel: WelcomeViewModel
    @Environment(\.modelContext) private var modelContext

    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.ccGray
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack {
                    Text("Welcome to")
                    Text("Currency Converter")
                }
                .font(.title)

                Spacer()

                switch viewModel.state {
                case .loading:
                    loadingStateView

                case .emptyData:
                    emptyStateView

                case .error:
                    VStack(spacing: 8) {
                        Text("Opps, something went wrong")

                        Button(
                            action: { viewModel.handleViewAction(.retry) },
                            label: {
                                Text("Try again")
                            }
                        )
                        .buttonStyle(.ccPrimary)
                    }
                    .padding(.bottom, 40)
                }
            }
            .foregroundStyle(.ccBlue)
            .padding(.horizontal)
        }
        .navigationDestination(item: $viewModel.tabBarViewModel) { tabBarViewModel in
            CCTabBarView(viewModel: tabBarViewModel)
                .transaction {
                    $0.disablesAnimations = true
                }
        }
        .onAppear {
            viewModel.handleViewAction(.viewAppeared(modelContext: modelContext))
        }
    }

    private var loadingStateView: some View {
        VStack {
            Text("Please wait")
            HStack {
                Text("We're trying to get available currencies")
                TimelineView(.animation(minimumInterval: 1, paused: false)) { context in
                    let dotsText = calculateDotsText(basedOn: context.date)
                    Text(dotsText)
                }
            }
        }
        .padding(.bottom, 40)
    }

    private var emptyStateView: some View {
        VStack {
            Text("Opps")
            Text("Unfortunately, couldn't find any currencies. Please try again later")
        }
        .padding(.bottom, 40)
    }

    private var errorStateView: some View {
        VStack {

        }
    }

    private func calculateDotsText(basedOn date: Date) -> String {
        let calendar = Calendar.current
        let dotsCount = calendar.component(.second, from: date) % 3

        if dotsCount == 1 {
            return ".  "
        } else if dotsCount == 2 {
            return ".. "
        } else {
            return "..."
        }
    }
}
