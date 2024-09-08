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
    
    func set<T: Codable>(_ value: T, for key: KeychainKey) {
        do {
            let data = try JSONEncoder().encode(value)
            keychain.set(data, forKey: key.rawValue)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func get<T: Codable>(_ type: T.Type, for key: KeychainKey) -> T? {
        guard let data = keychain.getData(key.rawValue) else { return nil }
        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
