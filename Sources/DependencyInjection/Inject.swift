//
//  Inject.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import Foundation

@propertyWrapper
struct Inject<Service> {
    
    var service: Service
    
    init(_ dependencyType: InstanceType = .transient) {
        guard let service = Container.resolve(dependencyType: dependencyType, Service.self) else {
            fatalError("No dependency of type \(String(describing: Service.self)) registered!")
        }
        self.service = service
    }
    
    var wrappedValue: Service {
        get { self.service }
        mutating set { service = newValue }
    }
}
