// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import SwiftUI

enum Theme: String {
    case light
    case dark
}

final class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .light
    
    private let userDefaultUseCase: UserDefaultUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    var isOn: Binding<Bool> {
        .init(get: { [weak self] in
            self?.currentTheme == .dark
        }, set: { [weak self] _ in
            self?.toggleTheme()
        })
    }
    
    init(userDefaultUseCase: UserDefaultUseCase = UserDefaultImp()) {
        self.userDefaultUseCase = userDefaultUseCase
        
        userDefaultUseCase
            .retrieveThemeSelection()
            .assign(to: &$currentTheme)
        
        $currentTheme
            .dropFirst()
            .handleEvents(receiveOutput: userDefaultUseCase.setThemeSelection(theme:))
            .sink(receiveValue: { _ in }) /// Find the better way to handle void subscribe - ignoreOutput, using subject
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension ThemeManager {
    func toggleTheme() {
        let newTheme = currentTheme
        switch newTheme {
        case .light: currentTheme = .dark
        case .dark: currentTheme = .light
        }
    }
}
