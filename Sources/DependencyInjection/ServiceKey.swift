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
//  ServiceKey.swift
//  
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

/// A key used for storing and retrieving services within the dependency injection container.
struct ServiceKey: Hashable {
    /// The type of the service associated with the key.
    let type: Any.Type
    
    /// Combines the type's name into the hasher for efficient storage and retrieval.
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
    
    /// Determines equality based on hash values for efficient comparison.
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
