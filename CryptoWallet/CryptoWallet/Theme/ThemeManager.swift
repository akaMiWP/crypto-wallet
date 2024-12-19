// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import SwiftUI

enum Theme {
    case light
    case dark
}

final class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .light
    
    var isOn: Binding<Bool> {
        .init(get: { [weak self] in
            self?.currentTheme == .dark
        }, set: { [weak self] _ in
            self?.toggleTheme()
        })
    }
    
    func toggleTheme() {
        switch currentTheme {
        case .light: currentTheme = .dark
        case .dark: currentTheme = .light
        }
    }
}
