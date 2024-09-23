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
    
    static let primaryViolet2_50: Color = { .init(hex: "#f0eff6") }()
    static let primaryViolet2_100: Color = { .init(hex: "#d0cee4") }()
    static let primaryViolet2_200: Color = { .init(hex: "#bab7d7") }()
    static let primaryViolet2_300: Color = { .init(hex: "#9a96c5") }()
    static let primaryViolet2_400: Color = { .init(hex: "#8681b9") }()
    static let primaryViolet2_500: Color = { .init(hex: "#6862a8") }()
    static let primaryViolet2_600: Color = { .init(hex: "#5f5999") }()
    static let primaryViolet2_700: Color = { .init(hex: "#4a4677") }()
    static let primaryViolet2_800: Color = { .init(hex: "#39365c") }()
    static let primaryViolet2_900: Color = { .init(hex: "#2c2947") }()
    
    static let secondaryGreen1_50: Color = { .init(hex: "#f4f9f9") }()
    static let secondaryGreen1_100: Color = { .init(hex: "#ddebeb") }()
    static let secondaryGreen1_200: Color = { .init(hex: "#cce1e2") }()
    static let secondaryGreen1_300: Color = { .init(hex: "#b5d3d5") }()
    static let secondaryGreen1_400: Color = { .init(hex: "#a6cbcd") }()
    static let secondaryGreen1_500: Color = { .init(hex: "#90bec0") }()
    static let secondaryGreen1_600: Color = { .init(hex: "#83adaf") }()
    static let secondaryGreen1_700: Color = { .init(hex: "#668788") }()
    static let secondaryGreen1_800: Color = { .init(hex: "#4f696a") }()
    static let secondaryGreen1_900: Color = { .init(hex: "#3c5051") }()
    
    static let secondaryGreen2_50: Color = { .init(hex: "#f6fdfa") }()
    static let secondaryGreen2_100: Color = { .init(hex: "#e4f8ee") }()
    static let secondaryGreen2_200: Color = { .init(hex: "#d7f4e6") }()
    static let secondaryGreen2_300: Color = { .init(hex: "#c5efda") }()
    static let secondaryGreen2_400: Color = { .init(hex: "#baecd3") }()
    static let secondaryGreen2_500: Color = { .init(hex: "#a9e7c8") }()
    static let secondaryGreen2_600: Color = { .init(hex: "#9ad2b6") }()
    static let secondaryGreen2_700: Color = { .init(hex: "#78a48e") }()
    static let secondaryGreen2_800: Color = { .init(hex: "#5d7f6e") }()
    static let secondaryGreen2_900: Color = { .init(hex: "#476154") }()
    
    static let supportRed_50: Color = { .init(hex: "#f7ebea") }()
    static let supportRed_100: Color = { .init(hex: "#e6c0be") }()
    static let supportRed_200: Color = { .init(hex: "#d9a29e") }()
    static let supportRed_300: Color = { .init(hex: "#c87772") }()
    static let supportRed_400: Color = { .init(hex: "#bd5d57") }()
    static let supportRed_500: Color = { .init(hex: "#ad342d") }()
    static let supportRed_600: Color = { .init(hex: "#9d2f29") }()
    static let supportRed_700: Color = { .init(hex: "#7b2520") }()
    static let supportRed_800: Color = { .init(hex: "#5f1d19") }()
    static let supportRed_900: Color = { .init(hex: "#491613") }()
    
    static let supportOrange_50: Color = { .init(hex: "#f8f3eb") }()
    static let supportOrange_100: Color = { .init(hex: "#e9d9c1") }()
    static let supportOrange_200: Color = { .init(hex: "#dec6a3") }()
    static let supportOrange_300: Color = { .init(hex: "#cfad79") }()
    static let supportOrange_400: Color = { .init(hex: "#c69d5f") }()
    static let supportOrange_500: Color = { .init(hex: "#b88437") }()
    static let supportOrange_600: Color = { .init(hex: "#a77832") }()
    static let supportOrange_700: Color = { .init(hex: "#835e27") }()
    static let supportOrange_800: Color = { .init(hex: "#65491e") }()
    static let supportOrange_900: Color = { .init(hex: "#4d3717") }()
    
    static let neutral_0: Color = { .init(hex: "#ffffff") }()
    static let neutral_10: Color = { .init(hex: "#fcfcfd") }()
    static let neutral_20: Color = { .init(hex: "#f9f9fc") }()
    static let neutral_30: Color = { .init(hex: "#f3f2f8") }()
    static let neutral_40: Color = { .init(hex: "#ebebf4") }()
    static let neutral_50: Color = { .init(hex: "#d9d8e9") }()
    static let neutral_60: Color = { .init(hex: "#d0cee4") }()
    static let neutral_70: Color = { .init(hex: "#c9c6e0") }()
    static let neutral_80: Color = { .init(hex: "#c0bdda") }()
    static let neutral_90: Color = { .init(hex: "#b7b4d5") }()
    
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
