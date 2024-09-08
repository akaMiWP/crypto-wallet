// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation
import KeychainSwift

enum KeychainKey: String {
    case seedPhrase
}

final class KeychainManager {
    
    static let shared: KeychainManager = .init()
    private let keychain: KeychainSwift = .init()
    
    private init() {}
    
    func set<T: Codable>(_ value: T, for key: KeychainKey) throws {
        let data = try JSONEncoder().encode(value)
        keychain.set(data, forKey: key.rawValue)
    }
    
    func get<T: Codable>(_ type: T.Type, for key: KeychainKey) throws -> T? {
        guard let data = keychain.getData(key.rawValue) else { return nil }
        let value = try JSONDecoder().decode(T.self, from: data)
        return value
    }
}
