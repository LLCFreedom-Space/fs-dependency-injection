// FS Dependency Injection
// Copyright (C) 2024  FREEDOM SPACE, LLC

//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  Container.swift
//
//
//  Created by Mykhailo Bondarenko on 21.01.2024.
//

import Foundation

/// A dependency injection container that manages the creation and resolution of services.
public final class Container: DIContainerProtocol {
    /// A shared instance of the container, accessible throughout the application.
    public static var shared = Container()
    /// A lock to ensure thread safety during registration and resolution.
    private let lock = NSRecursiveLock()
    /// An internal storage where services are registered and managed.
    private var storage: [ServiceKey: Service] = [:]
    
    /// Registers a service with the container.
    ///
    /// - Parameters:
    ///   - instanceType: The lifetime of the service instance (`transient` or `singleton`). Defaults to `transient`.
    ///   - type: The type of the service being registered.
    ///   - factory: A closure that creates an instance of the service when needed.
    public func register<T>(
        _ instanceType: InstanceType = .transient,
        to type: T.Type = T.self,
        factory: @escaping (Container) -> T
    ) {
        lock.lock()
        defer { lock.unlock() }
        storage[ServiceKey(type: type)] = Service(type: instanceType, factory: factory)
    }
    
    /// Registers a service with a fixed value, ensuring thread safety.
    ///
    /// - Parameters:
    ///   - instanceType: The lifetime of the service instance (defaults to `transient`).
    ///   - type: The type of the service being registered (defaults to inferred type).
    ///   - value: An autoclosure that provides the service instance's value.
    public func register<T>(_ instanceType: InstanceType = .transient, to type: T.Type = T.self, value: @escaping @autoclosure () -> T) {
        lock.lock()
        defer { lock.unlock() }
        let factory: (Container) -> T = { _ in value() }
        storage[ServiceKey(type: type)] = Service(type: instanceType, factory: factory)
    }
    
    /// Resolves a service from the container.
    ///
    /// - Parameter type: The type of the service to resolve.
    /// - Returns: The resolved service instance, or nil if not registered.
    public func resolve<T>(_ type: T.Type = T.self) -> T? {
        lock.lock()
        defer { lock.unlock() }
        let value: T? = storage[ServiceKey(type: type)]?.value(in: self)
        return value
    }
    
    /// Resolves a required service from the container.
    ///
    /// Triggers a precondition failure if the service is not registered.
    ///
    /// - Parameter type: The type of the service to resolve.
    /// - Returns: The resolved service instance.
    public func resolveRequired<T>(_ type: T.Type = T.self) -> T {
        guard let unwrapped: T = resolve() else {
            preconditionFailure("Unable to resolve service of type \(T.self). It is not registered.")
        }
        return unwrapped
    }
}
