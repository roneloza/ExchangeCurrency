//
//  ExchangeCurrencyReducer.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 26/10/21.
//

import Foundation

final class ExchangeCurrencyReducer: ReduxReducer<ExchangeCurrencyState> {
    
    override func reduce(state: ExchangeCurrencyState, action: ReduxAction) -> ExchangeCurrencyState {
        switch action {
        case let ExchangeCurrencyAction.setExchangeFocus(focus):
            return state.build(exchangeFocus: focus)
        case let ExchangeCurrencyAction.setReceiveAmount(amount):
            return state.build(receiveAmountString: amount)
        case let ExchangeCurrencyAction.setSendAmount(amount):
            return state.build(sendAmountString: amount)
        case let ExchangeCurrencyAction.setCurrentExchange(exchangeRate):
            return state.build(currentExchangeRate: exchangeRate.build(destination: state.currentExchangeRate.destination))
        case let ExchangeCurrencyAction.setCurrentExchangeDestination(currency):
            return state.build(currentExchangeRate: state.currentExchangeRate.build(destination: currency))
        case let ExchangeCurrencyAction.showSheetCurrencyList(show, option):
            return state.build(showSheetCurrencyList: show, exchangeOption: option)
        default:
            return state
        }
    }
    
}
