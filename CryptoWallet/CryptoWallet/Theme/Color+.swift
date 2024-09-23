// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

extension Color {
    static let primaryViolet1_50: Color = { .init(hex: "#f0e9f6") }()
    static let primaryViolet1_100: Color = { .init(hex: "#cfbce2") }()
    static let primaryViolet1_200: Color = { .init(hex: "#b89cd3") }()
    static let primaryViolet1_300: Color = { .init(hex: "#976ebf") }()
    static let primaryViolet1_400: Color = { .init(hex: "#8352b3") }()
    static let primaryViolet1_500: Color = { .init(hex: "#6427a0") }()
    static let primaryViolet1_600: Color = { .init(hex: "#5b2392") }()
    static let primaryViolet1_700: Color = { .init(hex: "#471c72") }()
    static let primaryViolet1_800: Color = { .init(hex: "#371558") }()
    static let primaryViolet1_900: Color = { .init(hex: "#2a1043") }()
}

// MARK: - Private
private extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 6: (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
