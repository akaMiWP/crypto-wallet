// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SettingsViewModel: ObservableObject {
    
    let rows: [SettingsRowViewModel] = [
        .init(rowType: .changeTheme),
        .init(rowType: .revealSeedPhrase)
    ]
    
    func didTapEditAccount() {}
    
    func didTapChangeTheme() {}
    
    func didTapRevealSeedPhrase() {}
}
