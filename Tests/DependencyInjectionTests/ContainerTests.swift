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
    
    func testRegisterAndResolveTransient() {
        container.register(.transient, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertTrue(instance1 !== instance2, "Transient instances should be different")
    }
    
    func testRegisterAndResolveSingleton() {
        container.register(.singleton, to: MockService.self) { _ in
            MockService()
        }
        
        let instance1 = container.resolve(MockService.self)
        let instance2 = container.resolve(MockService.self)
        
        XCTAssertTrue(instance1 === instance2, "Singleton instances should be the same")
    }
    
    func testResolveThrowingUnregisteredService() {
        XCTAssertThrowsError(try container.resolveThrowing(MockService.self))
    }
    
    func testResolveUnregisteredService() {
        XCTAssertNil(container.resolve(MockService.self))
    }
}

public class MockService: Equatable {
    var id: UUID = UUID()
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
