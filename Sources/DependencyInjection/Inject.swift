//
//  Inject.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import Foundation

@propertyWrapper
public final class Inject<Service> {
    
    public var wrappedValue: Service {
        get {
            if let cached = cachedValue { return cached }
            let value = resolve(in: .shared)
            cachedValue = value
            return value
        }
    }
    
    private var cachedValue: Service?
    
    public init() {}
    
    private func resolve(in container: Container) -> Service {
        container.resolveRequired()
    }
}
