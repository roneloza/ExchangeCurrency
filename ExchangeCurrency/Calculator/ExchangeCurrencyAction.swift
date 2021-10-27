//
//  ExchangeCurrencyAction.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 27/10/21.
//

import Foundation

enum ExchangeCurrencyAction: ReduxAction {
    
    case setReceiveAmount(_ amount: String)
    case setSendAmount(_ amount: String)
    case setCurrentExchange(_ exchangeRate: ExchangeRate)
    case setCurrentExchangeDestination(_ currency: Currency)
    case setExchangeFocus(_ focus: ExchangeFocus)
    case showSheetCurrencyList(show: Bool, option: ExchangeOption)
    
}
