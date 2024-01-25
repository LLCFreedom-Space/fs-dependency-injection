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
        container.register(.singleton, to: MockService.self) { _ in
            MockService()
        }
        
        @Inject var service: MockService
        @Inject var service1: MockService
        
        XCTAssertEqual(service, service1)
    }
    
    func testInjectTransient() {
        container.register(.transient, to: MockService.self) { _ in
            MockService()
        }
        
        @Inject var service: MockService
        @Inject var service1: MockService
        
        XCTAssertNotEqual(service, service1)
    }
}
