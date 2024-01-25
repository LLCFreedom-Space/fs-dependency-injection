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
//  Inject.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import Foundation

/// A property wrapper that injects dependencies from the dependency injection container.
@propertyWrapper
public final class Inject<Service> {
    /// The wrapped property value, representing the injected service.
    public var wrappedValue: Service {
        get {
            if let cached = cachedValue {
                return cached
            } // Reuse cached value if available
            let value = resolve(in: .shared) // Resolve from the shared container
            cachedValue = value // Cache for future access
            return value
        }
    }
    /// Cached value of the resolved service.
    private var cachedValue: Service?
    /// Initializes an Inject property wrapper.
    public init() {}
    /// Resolves the service from the specified container.
    private func resolve(in container: Container) -> Service {
        container.resolveRequired() // Obtain the service from the container
    }
}
