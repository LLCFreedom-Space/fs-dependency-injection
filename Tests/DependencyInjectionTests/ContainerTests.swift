//
//  ContainerTests.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import XCTest
@testable import DependencyInjection

final class ContainerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let container = Container()
        Container.shared = container
    }
    
    func testSharedInstanceResolvesToIdenticalInstance() {
        Container.register(type: DummyClass.self, as: .singleton, DummyClass())
        XCTAssertEqual(Container.resolve(DummyClass.self), Container.resolve(DummyClass.self))
    }
    
    func testTransientResolvesToDifferentInstance() {
        Container.register(type: DummyClass.self, as: .singleton, DummyClass())
        XCTAssertNotEqual(Container.resolve(DummyClass.self), Container.resolve(DummyClass.self))
    }
}

struct DummyClass: Equatable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
    init() {
        self.id = UUID()
    }
    
    
    static func == (lhs: DummyClass, rhs: DummyClass) -> Bool {
        return lhs.id == rhs.id
    }
    
}
