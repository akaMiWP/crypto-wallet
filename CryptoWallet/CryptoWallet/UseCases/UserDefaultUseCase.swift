// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

enum UserDefaultKeys: String {
    case hasCreatedWallet
    case themeSelection
}

protocol UserDefaultUseCase {
    func retrieveHasCreatedWallet() -> Bool
    func retrieveThemeSelection() -> AnyPublisher<Theme, Never>
    func setHasCreatedWallet(_ hasCreatedWallet: Bool)
    func setThemeSelection(theme: Theme)
}

final class UserDefaultImp: UserDefaultUseCase {
    func retrieveHasCreatedWallet() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
    }
    
    func retrieveThemeSelection() -> AnyPublisher<Theme, Never> {
        guard let themeString = UserDefaults.standard.value(forKey: UserDefaultKeys.themeSelection.rawValue) as? String,
              let theme: Theme = .init(rawValue: themeString) else {
            return Just(.light).eraseToAnyPublisher()
        }
        return Just(theme).eraseToAnyPublisher()
    }
    
    func setHasCreatedWallet(_ hasCreatedWallet: Bool) {
        UserDefaults.standard.setValue(hasCreatedWallet, forKey: UserDefaultKeys.hasCreatedWallet.rawValue)
    }
    
    func setThemeSelection(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: UserDefaultKeys.themeSelection.rawValue)
    }
}
