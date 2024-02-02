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
//  InjectTests.swift
//
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import XCTest
@testable import DependencyInjection

final class InjectTests: XCTestCase {
    var container = Container()
    
    override func setUp() {
        super.setUp()
        Container.shared = Container()
        container = .shared
    }
    
    func testInjectSingleton() {
        container.register(.singleton, to: MockService.self, value: MockService())
        
        @Inject var service: MockService
        @Inject var service1: MockService
        
        XCTAssertTrue(service === service1)
    }
    
    func testInjectTransient() {
        container.register(.transient, to: MockService.self, value: MockService())
        
        @Inject var service: MockService
        @Inject var service1: MockService
        
        XCTAssertNotEqual(service, service1)
        XCTAssertTrue(type(of: service) === type(of: service1))
    }
}
