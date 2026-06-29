//
//  Locked.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 04. 29..
//

import Foundation

@propertyWrapper
public struct Locked<Value> {
    private var value: Value
    private let lock = NSLock()

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            lock.withLock { value }
        }

        set {
            lock.withLock { value = newValue }
        }
    }
}
