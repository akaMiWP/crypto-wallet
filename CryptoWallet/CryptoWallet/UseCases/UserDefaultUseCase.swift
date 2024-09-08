// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

enum UserDefaultKeys: String {
    case hasCreatedWallet
}

protocol UserDefaultUseCase {
    var hasCreatedWallet: Bool { get set }
}

final class UserDefaultImp: UserDefaultUseCase {
    var hasCreatedWallet: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
        }
    }
}
