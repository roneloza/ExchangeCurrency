//
//  ExchangeCurrencyApp.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 26/10/21.
//

import SwiftUI

@main
struct ExchangeCurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            ExchangeCurrencyView(store: .init(state: ExchangeCurrencyState(),
                                              reducer: ExchangeCurrencyReducer()))
        }
    }
}
