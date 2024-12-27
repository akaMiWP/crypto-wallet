// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

class DIContainer {
    enum Scope {
        case transient, singleton
    }
    
    private var factories: [String: () -> Any] = [:]
    private var instances: [String: Any] = [:]

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }

    func resolve<T>(_ type: T.Type, scope: Scope = .singleton) -> T {
        let key = String(describing: type)
        if let instance = instances[key] as? T, scope == .singleton {
            return instance
        }
        
        guard let factory = factories[key], let instance = factory() as? T else {
            fatalError("No registered factory for type \(type)")
        }
        instances[key] = instance
        return instance
    }
}
