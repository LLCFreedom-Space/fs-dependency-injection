import Foundation

public final class Container {
    public typealias Factory<T> = () -> T
    public typealias ContainerFactory<T> = (Container) -> T
    
    public enum InstanceType: String {
        case transient
        case singleton
    }
    public static var shared = Container()
    
    private struct Key: Hashable {
        let type: Any.Type
        
        func hash(into hasher: inout Hasher) {
            hasher.combine("\(type)")
        }
        
        static func == (lhs: Key, rhs: Key) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
    
    private final class Entry {
        let behavior: InstanceType
        let factory: (Container) -> Any
        var cachedValue: Any?
        
        init(behavior: Container.InstanceType, factory: @escaping (Container) -> Any) {
            self.behavior = behavior
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
            if behavior == .singleton { cachedValue = value }
            return value
        }
    }
    
    private var parent: Container?
    private let lock = NSRecursiveLock()
    private var storage: [Key: Entry] = [:]
    
    public init(parent: Container? = nil) {
        self.parent = parent
    }
    
    public func register<T>(_ behavior: InstanceType = .transient, to type: T.Type = T.self, factory: @escaping ContainerFactory<T>) {
        lock.lock()
        storage[Key(type: type)] = Entry(behavior: behavior, factory: factory)
        lock.unlock()
    }
    
    public func resolve<T>(_ type: T.Type = T.self) -> T? {
        lock.lock()
        let value: T? = storage[Key(type: type)]?.value(in: self)
        lock.unlock()
        return value ?? parent?.resolve()
    }
    
    public func resolveThrowing<T>(_ type: T.Type = T.self) throws -> T {
        guard let unwrapped: T = resolve() else {
            throw ContainerError.notRegistered(type: T.self)
        }
        return unwrapped
    }
    
    public func resolveAssert<T>(_ type: T.Type = T.self) -> T {
        guard let unwrapped: T = resolve() else {
            preconditionFailure("Unable to resolve service of type \(T.self). It is not registered.")
        }
        return unwrapped
    }
}
