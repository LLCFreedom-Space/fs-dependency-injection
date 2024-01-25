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
//  DIContainerProtocol.swift
//
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

/// A protocol that defines the basic functionality of a dependency injection container.
public protocol DIContainerProtocol {
    /// Registers a service with the container.
    ///
    /// - Parameters:
    ///   - instanceType: The lifetime of the service instance (`transient` or `singleton`).
    ///   - type: The type of the service being registered.
    ///   - factory: A closure that creates an instance of the service when needed.
    func register<T>(_ instanceType: InstanceType, to type: T.Type, factory: @escaping (Container) -> T)
    
    /// Registers a service with a fixed value, providing control over its lifetime.
    ///
    /// - Parameters:
    ///   - instanceType: Specifies whether the service instance will be `transient` or `singleton`.
    ///   - type: The type of the service being registered.
    ///   - value: An autoclosure that provides the service instance's value.
    func register<T>(_ instanceType: InstanceType, to type: T.Type, value: @escaping @autoclosure () -> T)
    
    /// Resolves a service from the container.
    ///
    /// - Parameter type: The type of the service to resolve.
    /// - Returns: The resolved service instance, or nil if not registered.
    func resolve<T>(_ type: T.Type) -> T?
}
