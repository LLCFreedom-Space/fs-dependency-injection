//
//  Inject.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import Foundation

@propertyWrapper
public final class Inject<Service> {
    private var cachedValue: Service?

    public var wrappedValue: Service {
        get {
            if let cached = cachedValue { return cached }
            let value = resolve(in: .shared)
            cachedValue = value
            return value
        }
    }

    public init() {}

    private func resolve(in container: Container) -> Service {
        container.resolveAssert()
    }

//    public static subscript<EnclosingSelf>(
//        _enclosingInstance object: EnclosingSelf,
//        wrapped wrappedKeyPath: KeyPath<EnclosingSelf, Service>,
//        storage storageKeyPath: KeyPath<EnclosingSelf, Inject<Service>>
//    ) -> Service {
//        get {
//            let customContainer = (object as? ContainerProtocol)?.container ?? .shared
//            return object[keyPath: storageKeyPath].resolve(in: customContainer)
//        }
//    }
}
