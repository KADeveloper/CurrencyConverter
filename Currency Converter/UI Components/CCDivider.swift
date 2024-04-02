//
//  CCDivider.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 3/31/24.
//

import SwiftUI

struct CCDivider: View {
    var body: some View {
        Divider()
            .overlay(
                Color.ccBlue
                    .frame(height: UIScreen.main.scale / 2)
            )
    }
}
