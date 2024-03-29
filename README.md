# fs-dependency-injection

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
![GitHub release (with filter)](https://img.shields.io/github/v/release/LLCFreedom-Space/fs-dependency-injection)
[![Read the Docs](https://readthedocs.org/projects/docs/badge/?version=latest)](https://llcfreedom-space.github.io/fs-dependency-injection/)
![example workflow](https://github.com/LLCFreedom-Space/fs-dependency-injection/actions/workflows/docc.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-dependency-injection/actions/workflows/lint.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-dependency-injection/actions/workflows/test.yml/badge.svg?branch=main)
[![codecov](https://codecov.io/github/LLCFreedom-Space/fs-dependency-injection/graph/badge.svg?token=2EUIA4OGS9)](https://codecov.io/github/LLCFreedom-Space/fs-dependency-injection)

Dependency injection (DI) is a design pattern that allows components to be loosely coupled by providing their dependencies as arguments.
This can make code more modular, reusable, and testable.

The FSDependencyInjection library provides a simple and efficient way to implement DI in Swift.

## Installation

To install the DependencyInjection library, add the following dependency to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/LLCFreedom-Space/fs-dependency-injection.git", from: "1.0.0")
]
```

## Usage

To use the DependencyInjection library, you first need to create a Container instance.
The shared property provides a shared instance of the container that can be used throughout your application.

```swift
let container = Container.shared
```

Once you have a Container instance, you can register services with it. To register a service, you call the register() method.
The register() method takes two arguments: the type of the service to register and a factory closure that creates an instance of the service.

```swift
class MyService { ... }

// Use factory

container.register(
    to: MyService.self,
    factory: { container in
        MyService()
    }
)

// Or via value

container.register(
    to: MyService.self,
    value: MyService()
)
```

The factory closure can access the container to resolve other dependencies.

To resolve a service from the container, you call the resolve() method.
The resolve() method takes one argument: the type of the service to resolve.

```swift
let myService = container.resolve()
```

The resolve() method returns an optional value. If the service is not registered, the method returns nil.

## Lifetime of Services

The lifetime of a service instance can be either transient or singleton. Transient instances are created anew each time they are resolved. Singleton instances are shared across all requests.

The lifetime of a service instance can be specified when it is registered with the container. The `InstanceType` enum defines two cases:

* `transient`: The service instance is transient.
* `singleton`: The service instance is a singleton.

```swift
class MyService { ... }

container.register(
    to: MyService.self,
    instanceType: .singleton
)
```

## Property Wrappers

The `DependencyInjection` library also provides a property wrapper, `@Inject`, that can be used to inject dependencies into properties.

To use the `@Inject` property wrapper, you simply annotate the property with the wrapper.
The wrapper will automatically inject the appropriate service instance into the property.

```swift
class MyViewController {
    @Inject var myService: MyService
}
```

In this example, the myService property in MyViewController will be injected with a singleton instance of MyService.

## Example

Here is an example of how to use the `DependencyInjection` library:

```swift
class MyService {
    var name: String

    init(name: String) {
        self.name = name
    }
}

class MyViewController {
    @Inject var myService: MyService

    init() {
        myService.name = "Hello, world!"
    }

    func printName() {
        print(myService.name)
    }
}

let viewController = MyViewController()
viewController.printName()
```

This code will print the following output:

```swift
Hello, world!
```

## Links

LLC Freedom Space – [@LLCFreedomSpace](https://twitter.com/llcfreedomspace) – [support@freedomspace.company](mailto:support@freedomspace.company)

Distributed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3. See [LICENSE.md][license-url] for more information.

[GitHub](https://github.com/LLCFreedom-Space)

[swift-image]:https://img.shields.io/badge/swift-5.8-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-GPLv3-blue.svg
[license-url]: LICENSE
