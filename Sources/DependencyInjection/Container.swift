import Foundation

public final class Container {
    public static var shared = Container()
    private let lock = NSRecursiveLock()
    private var storage: [ServiceKey: Instance] = [:]
    
    public func register<T>(
        _ instanceType: InstanceType = .transient,
        to type: T.Type = T.self,
        factory: @escaping (Container) -> T
    ) {
        lock.lock()
        storage[ServiceKey(type: type)] = Instance(instanceType: instanceType, factory: factory)
        lock.unlock()
    }
    
    public func resolve<T>(_ type: T.Type = T.self) -> T? {
        lock.lock()
        let value: T? = storage[ServiceKey(type: type)]?.value(in: self)
        lock.unlock()
        return value
    }
    
    public func resolveRequired<T>(_ type: T.Type = T.self) -> T {
        guard let unwrapped: T = resolve() else {
            preconditionFailure("Unable to resolve service of type \(T.self). It is not registered.")
        }
        return unwrapped
    }
}

private final class Instance {
    let instanceType: InstanceType
    let factory: (Container) -> Any
    var cachedValue: Any?
    
    init(
        instanceType: InstanceType,
        factory: @escaping (Container) -> Any
    ) {
        self.instanceType = instanceType
        self.factory = factory
        self.cachedValue = nil
    }
    
    func value<T>(in container: Container) -> T {
        guard let value = valueAny(in: container) as? T else {
            preconditionFailure("Internal storage type mismatch.")
        }
        return value
    }
    
    private func valueAny(in container: Container) -> Any {
        cachedValue ?? create(in: container)
    }
    
    private func create(in container: Container) -> Any {
        let value = factory(container)
        if instanceType == .singleton { cachedValue = value }
        return value
    }
}
