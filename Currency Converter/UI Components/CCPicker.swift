//
//  CCPicker.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import SwiftUI

struct CurrencyPickerView<SelectionValue: Hashable>: View {
    let title: String
    let selection: Binding<SelectionValue>
    let currencies: [CurrencyModel]

    var body: some View {
        Picker(title, selection: selection) {
            ForEach(currencies, id: \.id) {
                Text($0.code)
                    .tag($0 as CurrencyModel)
            }
        }
        .pickerStyle(.menu)
    }
}
