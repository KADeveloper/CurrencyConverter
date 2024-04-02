//
//  View+ButtonStyle.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import SwiftUI

extension ButtonStyle where Self == CCPrimaryButtonStyle {
    static var ccPrimary: CCPrimaryButtonStyle {
        CCPrimaryButtonStyle()
    }
}

struct CCPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        let enabledBackgroundColor = configuration.isPressed ? Color.blue : Color.ccBlue
        let backgroundColor = isEnabled ? enabledBackgroundColor : Color(uiColor: .darkGray)

        let textColor = isEnabled ? Color.white : Color.ccGray

        ZStack {
            backgroundColor

            configuration.label
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(textColor)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
        }
        .frame(height: 40)
        .contentShape(.capsule)
        .clipShape(.capsule)
    }
}
