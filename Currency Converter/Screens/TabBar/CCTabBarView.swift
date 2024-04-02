//
//  CCTabBarView.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import SwiftUI

struct CCTabBarView: View {
    @State private var viewModel: CCTabBarViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(viewModel.tabs, id: \.id) { tab in
                switch tab {
                case .converter:
                    ConverterView(viewModel: viewModel.converterViewModel)
                        .tabBarItem(title: "Converter",
                                    icon: Image(.converterIcon),
                                    tag: tab)

                case .history:
                    HistoryView(viewModel: viewModel.historyViewModel)
                        .tabBarItem(title: "History",
                                    icon: Image(.historyIcon),
                                    tag: tab)
                }
            }
        }
        .tint(.ccBlue)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            UITabBar.appearance().backgroundColor = .systemGray5
            UITabBar.appearance().unselectedItemTintColor = .systemGray
        }
    }

    init(viewModel: CCTabBarViewModel) {
        self.viewModel = viewModel
    }
}
