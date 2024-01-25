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
//  InstanceType.swift
//
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

/// The lifetime of a service instance.
public enum InstanceType: String {
    /// A transient instance is created anew each time it is resolved.
    case transient
    /// A singleton instance is shared across all requests.
    case singleton
    
    /// Returns a human-readable description of the instance type.
    public var description: String {
        switch self {
        case .transient: return "Transient"
        case .singleton: return "Singleton"
        }
    }
}
