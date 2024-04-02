//
//  View+Navigation.swift
//  Currency Converter
//
//  Created by Aleksei Kudriashov on 4/1/24.
//

import SwiftUI

extension View {
    func navigationDestination<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        let isPresented: Binding<Bool> = Binding(get: { item.wrappedValue != nil },
                                                 set: { _ in item.wrappedValue = nil })
        return self.navigationDestination(isPresented: isPresented) {
            if let item = item.wrappedValue {
                destination(item)
            }
        }
    }
}
