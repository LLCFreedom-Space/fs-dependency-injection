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
    var container = Container()
    
    override func setUp() {
        super.setUp()
        Container.shared = Container()
        container = .shared
    }
    
    func testRegisterFactoryAndResolveTransient() throws {
        container.register(.transient, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = try XCTUnwrap(container.resolve(MockService.self))
        let instance2 = try XCTUnwrap(container.resolve(MockService.self))
        
        XCTAssertNotEqual(instance1, instance2)
        XCTAssertTrue(type(of: instance1) === type(of: instance2))
    }
    
    func testRegisterFactoryAndResolveSingleton() {
        container.register(.singleton, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testRegisterValueAndResolveTransient() {
        container.register(.transient, to: MockService.self, value: MockService())
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertNotEqual(instance1, instance2)
    }
    
    func testRegisterValueAndResolveSingleton() {
        container.register(.singleton, to: MockService.self, value: MockService())
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertEqual(instance1, instance2)
    }
    
    func testResolveUnregisteredService() {
        XCTAssertNil(container.resolve(MockService.self))
    }
}

internal class MockService: Equatable {
    var id = UUID()
    public var didCallFoo = false
    public var didCallBar = false
    
    public func foo() {
        didCallFoo = true
    }
    
    public func bar() {
        didCallBar = true
    }
    
    public static func == (lhs: MockService, rhs: MockService) -> Bool {
        return lhs.id == rhs.id &&
        lhs.didCallFoo == rhs.didCallFoo &&
        lhs.didCallBar == rhs.didCallBar
    } 
}
