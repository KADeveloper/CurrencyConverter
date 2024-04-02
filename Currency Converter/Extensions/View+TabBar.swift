//
//  View+TabBar.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/30/24.
//

import SwiftUI

extension View {
    func tabBarItem<Tag: Hashable>(title: String,
                                   icon: Image,
                                   tag: Tag) -> some View {
        tabItem {
            Label {
                Text(title)
            } icon: {
                icon.renderingMode(.template)
            }
        }
        .tag(tag)
    }
}
