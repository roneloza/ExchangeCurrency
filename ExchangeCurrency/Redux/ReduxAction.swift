//
//  ReduxAction.swift
//  ExchangeCurrency
//
//  Created by Rone Shender on 26/10/21.
//

import Foundation
import Combine

public protocol CoordinatorAction: ReduxAction {}

public protocol FlowAction: ReduxAction {}

public protocol ReduxAction {
    
    var wait: Bool { get }
    
}

public extension ReduxAction {
    
    var wait: Bool { false }
    
}

public protocol DispatcherObject: AnyObject {
    
    func dispatch(_ action: ReduxAction)
    func addChild(store: DispatcherObject)
    func addParent(store: DispatcherObject?)
    
}

public protocol ListenerObject: class {
    
    var dispatcher: DispatcherObject? { get set }
    
}

public extension ListenerObject {
    
    weak var dispatcher: DispatcherObject? {
        get { nil }
        set { _ = newValue }
    }
    
}

public protocol MiddlewareListenerObject: ListenerObject {
    
    var subscriptions: Set<AnyCancellable> { get }
    func handleDispatch(action: ReduxAction,
                        store: DispatcherObject,
                        parent: DispatcherObject?)
    
}

public protocol CoordinatorListenerObject: ListenerObject {
    
    func handleDispatch(action: ReduxAction,
                        store: DispatcherObject,
                        parent: DispatcherObject?) -> Bool
    
}

public extension CoordinatorListenerObject {
    
    func handleDispatch(action: ReduxAction,
                        store: DispatcherObject,
                        parent: DispatcherObject?) -> Bool {
        return false
    }
    
}
