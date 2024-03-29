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
//  ContainerTests.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import XCTest
@testable import DependencyInjection

final class ContainerTests: XCTestCase {
    /// Container instance used for testing.
    var container = Container()
    
    override func setUp() {
        super.setUp()
        // Reset the shared container to ensure isolation for each test
        Container.shared = Container()
        container = .shared
    }
    
    /// Tests registering a service factory for transient instances and resolving them.
    func testRegisterFactoryAndResolveTransient() throws {
        container.register(.transient, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = try XCTUnwrap(container.resolve(MockService.self))
        let instance2 = try XCTUnwrap(container.resolve(MockService.self))
        
        XCTAssertNotEqual(instance1, instance2)
        XCTAssertTrue(type(of: instance1) === type(of: instance2))
    }
    
    /// Tests registering a service factory for singleton instances and resolving them.
    func testRegisterFactoryAndResolveSingleton() {
        container.register(.singleton, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertTrue(instance1 === instance2)
    }
    
    /// Tests registering a service with a fixed value for transient instances and resolving them.
    func testRegisterValueAndResolveTransient() {
        container.register(.transient, to: MockService.self, value: MockService())
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertNotEqual(instance1, instance2)
    }
    
    /// Tests registering a service with a fixed value for singleton instances and resolving them.
    func testRegisterValueAndResolveSingleton() {
        container.register(.singleton, to: MockService.self, value: MockService())
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertEqual(instance1, instance2)
    }
    
    /// Tests resolving an unregistered service.
    func testResolveUnregisteredService() {
        XCTAssertNil(container.resolve(MockService.self))
    }
}

/// Internal Mock Service implementation
internal class MockService: Equatable {
    /// Unique identifier for each instance
    var id = UUID()
    /// Flag for tracking method calls
    public var didCallFoo = false
    /// Flag for tracking method calls
    public var didCallBar = false
    
    /// Mock service method
    public func foo() {
        didCallFoo = true
    }
    
    /// Mock service method
    public func bar() {
        didCallBar = true
    }
    
    /// Equality check for MockService instances
    public static func == (lhs: MockService, rhs: MockService) -> Bool {
        return lhs.id == rhs.id &&
        lhs.didCallFoo == rhs.didCallFoo &&
        lhs.didCallBar == rhs.didCallBar
    } 
}
