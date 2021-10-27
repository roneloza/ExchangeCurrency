//
//  ExchangeCurrencyState.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 26/10/21.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func rounded(toPlaces places: Int) -> String {
        String(format:"%.\(places)f", self)
    }
    
}

enum ExchangeFocus {
    
    case send, receive
    
}

enum ExchangeOption {
    
    case send, receive
    
}

struct ExchangeCurrencyState: ReduxState {
    
    var sendAmount: Double {
        Double(self.sendAmountString) ?? 0.0
    }
    var receiveAmount: Double {
        Double(self.receiveAmountString) ?? 0.0
    }
    var sendAmountString: String
    var receiveAmountString: String
    let currentExchangeRate: ExchangeRate
    let exchangeFocus: ExchangeFocus
    var showSheetCurrencyList: Bool
    let exchangeOption: ExchangeOption
    
    init(sendAmountString: String  = "",
         receiveAmountString: String = "",
         currentExchangeRate: ExchangeRate = ExchangeRate.allExchangeRate.first { $0.source == .PEN }!,
         exchangeFocus: ExchangeFocus = .send,
         showSheetCurrencyList: Bool = false,
         exchangeOption: ExchangeOption = .send) {
        self.sendAmountString = sendAmountString
        self.receiveAmountString = receiveAmountString
        self.currentExchangeRate = currentExchangeRate
        self.exchangeFocus = exchangeFocus
        self.showSheetCurrencyList = showSheetCurrencyList
        self.exchangeOption = exchangeOption
    }
    
    func build(sendAmountString: String? = nil,
               receiveAmountString: String? = nil,
               currentExchangeRate: ExchangeRate? = nil,
               exchangeFocus: ExchangeFocus? = nil,
               showSheetCurrencyList: Bool? = nil,
               exchangeOption: ExchangeOption? = nil) -> ExchangeCurrencyState {
        .init(sendAmountString: sendAmountString ?? self.sendAmountString,
              receiveAmountString: receiveAmountString ?? self.receiveAmountString,
              currentExchangeRate: currentExchangeRate ?? self.currentExchangeRate,
              exchangeFocus: exchangeFocus ?? self.exchangeFocus,
              showSheetCurrencyList: showSheetCurrencyList ?? self.showSheetCurrencyList,
              exchangeOption: exchangeOption ?? self.exchangeOption)
    }
    
}

enum Currency: String, Identifiable {
    
    case USD = "USD"
    case EUR = "EURO"
    case JPY = "JPY"
    case GBP = "GBP"
    case CHF = "CHF"
    case CAD = "CAD"
    case PEN = "PEN"
    
    var id: UUID { UUID() }
    
    var countryName: String {
        switch self {
        case .USD: return "United States"
        case .EUR: return "European Union"
        case .JPY: return "Japan"
        case .GBP: return "United Kingdom"
        case .CHF: return "Switzerland"
        case .CAD: return "Canada"
        case .PEN: return "Peru"
        }
    }
    
    var currencyName: String {
        switch self {
        case .USD: return "United States Dollar"
        case .EUR: return "Euro"
        case .JPY: return "Japanese Yen"
        case .GBP: return "Pound Sterling"
        case .CHF: return "Swiss Franc"
        case .CAD: return "Canadian Dollar"
        case .PEN: return "Sol"
        }
    }
    
    var flag: String {
        switch self {
        case .USD: return "🇺🇸"
        case .EUR: return "🇪🇺"
        case .JPY: return "🇯🇵"
        case .GBP: return "🇬🇧"
        case .CHF: return "🇨🇭"
        case .CAD: return "🇨🇦"
        case .PEN: return "🇵🇪"
        }
    }
    
}

struct Rate: ReduxState {
    
    let buy,sell: Double
    
    init(buy: Double, sell: Double) {
        self.buy = buy
        self.sell = sell
    }
    
}

struct ExchangeRate: Identifiable, ReduxState {
    
    let id = UUID()
    let source: Currency
    let destination: Currency
    let rates: [Currency: Rate]
    static var allExchangeRate: [ExchangeRate] = [
        .init(source: .USD, destination: .PEN, rates: [ .USD : Rate(buy: 1.0, sell: 1.0),
                                                        .EUR : Rate(buy: 0.86, sell: 0.89),
                                                        .JPY : Rate(buy: 114.01, sell: 114.04),
                                                        .GBP : Rate(buy: 0.73, sell: 0.76),
                                                        .CHF : Rate(buy: 0.92, sell: 0.95),
                                                        .CAD : Rate(buy: 1.24, sell: 1.27),
                                                        .PEN : Rate(buy: 3.99, sell: 4.02)]),
        .init(source: .EUR, destination: .PEN, rates: [ .USD : Rate(buy: 1.16, sell: 1.19),
                                                        .EUR : Rate(buy: 1.0, sell: 1.0),
                                                        .JPY : Rate(buy: 132.34, sell: 132.37),
                                                        .GBP : Rate(buy: 0.84, sell: 0.87),
                                                        .CHF : Rate(buy: 1.07, sell: 1.20),
                                                        .CAD : Rate(buy: 1.44, sell: 1.47),
                                                        .PEN : Rate(buy: 4.63, sell: 4.66)]),
        .init(source: .JPY, destination: .PEN, rates: [ .USD : Rate(buy: 0.0088, sell: 0.0091),
                                                        .EUR : Rate(buy: 0.0076, sell: 0.0079),
                                                        .JPY : Rate(buy: 1.0, sell: 1.0),
                                                        .GBP : Rate(buy: 0.0064, sell: 0.0067),
                                                        .CHF : Rate(buy: 0.0081, sell: 0.0084),
                                                        .CAD : Rate(buy: 0.011, sell: 0.014),
                                                        .PEN : Rate(buy: 0.035, sell: 0.038)]),
        .init(source: .GBP, destination: .PEN, rates: [ .USD : Rate(buy: 1.38, sell: 1.41),
                                                        .EUR : Rate(buy: 1.19, sell: 1.22),
                                                        .JPY : Rate(buy: 157.05, sell: 157.09),
                                                        .GBP : Rate(buy: 1.0, sell: 1.0),
                                                        .CHF : Rate(buy: 1.27, sell: 1.30),
                                                        .CAD : Rate(buy: 1.71, sell: 1.74),
                                                        .PEN : Rate(buy: 5.49, sell: 5.52)]),
        .init(source: .CHF, destination: .PEN, rates: [ .USD : Rate(buy: 1.09, sell: 1.12),
                                                        .EUR : Rate(buy: 0.94, sell: 0.97),
                                                        .JPY : Rate(buy: 124.05, sell: 124.08),
                                                        .GBP : Rate(buy: 0.79, sell: 0.82),
                                                        .CHF : Rate(buy: 1.0, sell: 1.0),
                                                        .CAD : Rate(buy: 1.35, sell: 1.38),
                                                        .PEN : Rate(buy: 4.34, sell: 4.37)]),
        .init(source: .CAD, destination: .PEN, rates: [ .USD : Rate(buy: 0.81, sell: 0.84),
                                                        .EUR : Rate(buy: 0.70, sell: 0.73),
                                                        .JPY : Rate(buy: 92.03, sell: 92.06),
                                                        .GBP : Rate(buy: 0.59, sell: 0.62),
                                                        .CHF : Rate(buy: 0.74, sell: 0.77),
                                                        .CAD : Rate(buy: 1.0, sell: 1.0),
                                                        .PEN : Rate(buy: 3.22, sell: 3.25)]),
        .init(source: .PEN, destination: .USD, rates: [ .USD : Rate(buy: 0.25, sell: 0.28),
                                                        .EUR : Rate(buy: 0.22, sell: 0.25),
                                                        .JPY : Rate(buy: 28.62, sell: 28.65),
                                                        .GBP : Rate(buy: 0.18, sell: 0.21),
                                                        .CHF : Rate(buy: 0.23, sell: 0.26),
                                                        .CAD : Rate(buy: 0.31, sell: 0.34),
                                                        .PEN : Rate(buy: 1.0, sell: 1.0)])
    ]
    
    init(source: Currency, destination: Currency, rates: [Currency : Rate]) {
        self.source = source
        self.destination = destination
        self.rates = rates
    }
    
    func build(source: Currency? = nil, destination: Currency? = nil, rates: [Currency : Rate]? = nil) -> Self {
        .init(source: source ?? self.source, destination: destination ?? self.destination, rates: rates ?? self.rates)
    }
    
}
