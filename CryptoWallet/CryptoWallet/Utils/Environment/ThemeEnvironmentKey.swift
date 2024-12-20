// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ThemeManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeManager = .init()
}

extension EnvironmentValues {
    var theme: ThemeManager {
        get { self[ThemeManagerEnvironmentKey.self] }
        set { self[ThemeManagerEnvironmentKey.self] = newValue }
    }
}
