//
//  ExchangeCurrencyListView.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 27/10/21.
//

import SwiftUI

struct ExchangeCurrencyListView: View {
    
    private(set) var store: ReduxStore<ExchangeCurrencyState>
    private let currencies: [Currency]
    private let currentExchangeRate: ExchangeRate
    
    var body: some View {
        VStack(spacing: 0) {
            Image("icon-bcp")
                .resizable()
                .scaledToFit()
                .frame(height: 100, alignment: .top)
                .clipped()
            VStack {
                List {
                    ForEach(self.currencies) { currency in
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Spacer()
                                HStack(spacing: 8) {
                                    Text(currency.flag)
                                        .font(.system(size: 50))
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(currency.countryName)
                                                .font(.system(size: 14))
                                            Spacer()
                                        }
                                        HStack {
                                            Text("1 \(currentExchangeRate.source.rawValue) = \(String(format:"%.4f", currentExchangeRate.rates[currency]!.buy)) \(currency.rawValue)")
                                                .font(.system(size: 14))
                                            Spacer()
                                        }
                                    }
                                    if currentExchangeRate.source == currency &&
                                        self.store.state.exchangeOption == .send {
                                        Image(systemName: "checkmark")
                                    } else if currentExchangeRate.destination == currency &&
                                                self.store.state.exchangeOption == .receive {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if self.store.state.exchangeOption == .send {
                                self.store.dispatch(ExchangeCurrencyAction.setCurrentExchange(ExchangeRate.allExchangeRate.first { $0.source == currency }!))
                            } else {
                                self.store.dispatch(ExchangeCurrencyAction.setCurrentExchangeDestination(currency))
                            }
                            self.store.dispatch(ExchangeCurrencyAction.showSheetCurrencyList(show: false, option: self.store.state.exchangeOption))
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    init(currencies: [Currency],
         currentExchangeRate: ExchangeRate,
         store: ReduxStore<ExchangeCurrencyState>) {
        self.currencies = currencies
        self.currentExchangeRate = currentExchangeRate
        self.store = store
    }
    
}

struct ExchangeCurrencyListView_Previews: PreviewProvider {
    
    static let currencies = ExchangeRate.allExchangeRate.compactMap { $0.source }.sorted { $0.countryName < $1.countryName }
    static var previews: some View {
        ExchangeCurrencyListView(currencies: currencies,
                                 currentExchangeRate: ExchangeRate.allExchangeRate.first { $0.source == .USD }!,
                                 store: .init(state: ExchangeCurrencyState(),
                                              reducer: ExchangeCurrencyReducer()))
    }
}
