//
//  View+Extension.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 27/10/21.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
