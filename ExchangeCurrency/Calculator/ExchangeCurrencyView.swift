//
//  ContentView.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 26/10/21.
//

import SwiftUI

struct ExchangeCurrencyView: ReduxStoreView {
    
    @ObservedObject private(set) var store: ReduxStore<ExchangeCurrencyState>
    @State private var showEndTransactionAlert: Bool = false
    
    var body: some View {
        self.onChangeSendAmountTextField()
        self.onChangeReceiveAmountTextField()
        return
            VStack(spacing: 0) {
                Image("icon-bcp")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150, alignment: .top)
                    .clipped()
                VStack(spacing: 0) {
                    Spacer()
                    ZStack {
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("You send:")
                                            Spacer()
                                        }
                                        TextField("0.00",
                                                  text: self.$store.state.sendAmountString,
                                                  onEditingChanged: { (editing) in
                                                    self.store.dispatch(ExchangeCurrencyAction.setExchangeFocus(.send))
                                                  })
                                            .keyboardType(.decimalPad)
                                            .frame(height: 40, alignment: .leading)
                                    }
                                    Button(action: {
                                        self.store.dispatch(ExchangeCurrencyAction.showSheetCurrencyList(show: true, option: .send))
                                    }, label: {
                                        VStack(spacing: 0) {
                                            VStack(spacing: 0) {
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 2) {
                                                        Text(self.store.state.currentExchangeRate.source.currencyName)
                                                            .font(.system(size: 14))
                                                            .multilineTextAlignment(.center)
                                                        Text(self.store.state.currentExchangeRate.source.flag)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.down")
                                                    Spacer()
                                                        .frame(width: 8)
                                                }
                                                Spacer()
                                            }
                                        }
                                        .background(Color.gray)
                                        .foregroundColor(.black)
                                    })
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 16)
                            }
                            .background(Color.white)
                            Divider().frame(height: 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("You receive:")
                                            Spacer()
                                        }
                                        TextField("0.00",
                                                  text: self.$store.state.receiveAmountString,
                                                  onEditingChanged: { (editing) in
                                                    self.store.dispatch(ExchangeCurrencyAction.setExchangeFocus(.receive))
                                                  })
                                            .keyboardType(.decimalPad)
                                            .frame(height: 40, alignment: .leading)
                                    }
                                    Button(action: {
                                        self.store.dispatch(ExchangeCurrencyAction.showSheetCurrencyList(show: true, option: .receive))
                                    }, label: {
                                        VStack(spacing: 0) {
                                            VStack(spacing: 0) {
                                                Spacer()
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 2) {
                                                        Text(self.store.state.currentExchangeRate.destination.currencyName)
                                                            .font(.system(size: 14))
                                                            .multilineTextAlignment(.center)
                                                        Text(self.store.state.currentExchangeRate.destination.flag)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.down")
                                                    Spacer()
                                                        .frame(width: 8)
                                                }
                                                Spacer()
                                            }
                                        }
                                        .background(Color.gray)
                                        .foregroundColor(.black)
                                    })
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 16)
                            }
                            .background(Color.white)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color(red: 0.7569, green: 0.7608, blue: 0.7608))
                        )
                        .cornerRadius(16)
                        Button(action: {
                            self.store.dispatch(ExchangeCurrencyAction.setCurrentExchange(ExchangeRate.allExchangeRate.first { $0.source == self.store.state.currentExchangeRate.destination }!))
                            self.store.dispatch(ExchangeCurrencyAction.setCurrentExchangeDestination(self.store.state.currentExchangeRate.source))
                        }, label: {
                            Text("🔄")
                                .font(.system(size: 40))
                        })
                    }
                    Spacer()
                    Text("We bought \(self.store.state.currentExchangeRate.destination.rawValue) \(ExchangeRate.allExchangeRate.first { $0.source == self.store.state.currentExchangeRate.destination }!.rates[self.store.state.currentExchangeRate.source]!.buy.rounded(toPlaces: 4)) \n We sell \(self.store.state.currentExchangeRate.destination.rawValue) \(ExchangeRate.allExchangeRate.first { $0.source == self.store.state.currentExchangeRate.destination }!.rates[self.store.state.currentExchangeRate.source]!.sell.rounded(toPlaces: 4))")
                    Spacer()
                    Button(action: {
                        self.showEndTransactionAlert = true
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Begin Transaction")
                            Spacer()
                        }
                        .padding()
                    })
                    .foregroundColor(.white)
                    .background(self.store.state.sendAmount > 10 ? Color.blue : Color.blue.opacity(0.5))
                    .fixedSize(horizontal: false, vertical: false)
                    .disabled(self.store.state.sendAmount < 10)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.hideKeyboard()
            }
            .sheet(isPresented: self.$store.state.showSheetCurrencyList) {
                if self.store.state.exchangeOption == .send {
                    ExchangeCurrencyListView(
                        currencies: ExchangeRate.allExchangeRate.compactMap { $0.source }.sorted { $0.countryName < $1.countryName },
                        currentExchangeRate: self.store.state.currentExchangeRate,
                        store: self.store)
                } else {
                    ExchangeCurrencyListView(
                        currencies: self.store.state.currentExchangeRate.rates.compactMap { $0.key }.sorted { $0.countryName < $1.countryName },
                        currentExchangeRate: self.store.state.currentExchangeRate,
                        store: self.store)
                }
            }
            .alert(isPresented: self.$showEndTransactionAlert, content: {
                .init(title: Text("Processing Transaction"),
                      message: Text("We wait for your deposit to send your currency exchange"),
                      dismissButton: .cancel(Text("Accept"), action: {
                        self.store.dispatch(ExchangeCurrencyAction.setSendAmount(""))
                      }))
            })
        
    }
    
    private func onChangeSendAmountTextField() {
        if self.store.state.exchangeFocus == .send {
            let receiveAmount = (self.store.state.sendAmount * (self.store.state.currentExchangeRate.rates[self.store.state.currentExchangeRate.destination]!.buy))
            self.store.dispatch(ExchangeCurrencyAction.setReceiveAmount(receiveAmount.rounded(toPlaces: 2)))
        }
    }
    
    private func onChangeReceiveAmountTextField() {
        if self.store.state.exchangeFocus == .receive {
            let sendAmount = (self.store.state.receiveAmount / (self.store.state.currentExchangeRate.rates[self.store.state.currentExchangeRate.destination]!.buy))
            self.store.dispatch(ExchangeCurrencyAction.setSendAmount(sendAmount.rounded(toPlaces: 2)))
        }
    }
    
}

struct ExchangeCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeCurrencyView(store: .init(state: ExchangeCurrencyState(),
                                          reducer: ExchangeCurrencyReducer()))
    }
}
