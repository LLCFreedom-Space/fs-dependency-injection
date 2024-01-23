//
//  Container.swift
//
//
//  Created by Mykhailo Bondarenko on 23.01.2024.
//

import Foundation

public final class Container {
    static var shared = Container()
    
    private static var cache: [String: Any] = [:]
    private static var generators: [String: () -> Any] = [:]
    
    static func register<T>(type: T.Type, as serviceType: InstanceType = .automatic, _ factory: @autoclosure @escaping () -> T) {
        generators[String(describing: type.self)] = factory
        
        if serviceType == .singleton {
            cache[String(describing: type.self)] = factory()
        }
    }
    
    static func resolve<T>(dependencyType: InstanceType = .automatic, _ type: T.Type) -> T? {
        let key = String(describing: type.self)
        switch dependencyType {
        case .singleton:
            if let cachedService = cache[key] as? T {
                return cachedService
            } else {
                fatalError("\(String(describing: type.self)) is not registeres as singleton")
            }
            
        case .automatic:
            if let cachedService = cache[key] as? T {
                return cachedService
            }
            fallthrough
            
        case .transient:
            if let service = generators[key]?() as? T {
                cache[String(describing: type.self)] = service
                return service
            } else {
                return nil
            }
        }
    }
}

enum InstanceType: String {
    /// A new instance should be created at every `.resolve(...)`.
    case transient
    /// A new instance should be created once per container.
    case singleton
    
    case automatic
}
