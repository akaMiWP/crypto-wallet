// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

enum UserDefaultKeys: String {
    case hasCreatedWallet
}

protocol UserDefaultUseCase {
    func retrieveHasCreatedWallet() -> Bool
    func setHasCreatedWallet(_ hasCreatedWallet: Bool)
}

final class UserDefaultImp: UserDefaultUseCase {
    func retrieveHasCreatedWallet() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
    }
    
    func setHasCreatedWallet(_ hasCreatedWallet: Bool) {
        UserDefaults.standard.setValue(hasCreatedWallet, forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
    }
}
