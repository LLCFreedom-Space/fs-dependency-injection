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
//  Service.swift
//
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

/// Represents a registered service with its instance type and creation logic.
internal final class Service {
    /// The lifetime of the service instance (`transient` or `singleton`).
    let type: InstanceType
    /// A closure that creates an instance of the service when needed.
    let factory: (Container) -> Any
    /// Cached value for singleton instances.
    var instance: Any?
    
    /// Initializes an Service with the given instance type and factory closure.
    init(
        type: InstanceType,
        factory: @escaping (Container) -> Any
    ) {
        self.type = type
        self.factory = factory
        self.instance = nil
    }
    
    /// Retrieves the value of the service instance, ensuring type safety.
    ///
    /// - Parameter container: The container used for resolving dependencies (if needed).
    /// - Returns: The resolved service instance.
    func value<T>(in container: Container) -> T {
        guard let value = fetchValue(from: container) as? T else {
            preconditionFailure("Type mismatch.")
        }
        return value
    }
    
    /// Retrieves the value of the service instance as Any.
    ///
    /// - Parameter container: The container used for resolving dependencies (if needed).
    /// - Returns: The resolved service instance as Any.
    private func fetchValue(from container: Container) -> Any {
        instance ?? create(in: container)
    }
    
    /// Creates a new instance of the service using the factory closure.
    ///
    /// - Parameter container: The container used for resolving dependencies (if needed).
    /// - Returns: The newly created service instance.
    private func create(in container: Container) -> Any {
        let value = factory(container)
        if type == .singleton { instance = value }
        return value
    }
}
