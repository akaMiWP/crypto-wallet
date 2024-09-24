// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct PrimaryButton: View {
    
    enum `Type` {
        case primaryPurple
        case secondaryPurple
        case primaryGreen
        case secondaryGreen
    }
    
    private let title: String
    private let type: `Type`
    private let action: () -> Void
    
    init(title: String, type: `Type` = .primaryPurple, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(type.foregroundColor)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(type.backgroundColor)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(type.borderColor, lineWidth: type.borderWidth)
        )
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Primary Purple", type: .primaryPurple, action: {})
        PrimaryButton(title: "Secondary Purple", type: .secondaryPurple, action: {})
        PrimaryButton(title: "Primary Green", type: .primaryGreen, action: {})
        PrimaryButton(title: "Secondary Green", type: .secondaryGreen, action: {})
    }
    .padding(.horizontal)
    .frame(maxHeight: .infinity)
    .background(Color.primaryViolet1_900)
}

// MARK: - Private
private extension PrimaryButton.`Type` {
    var foregroundColor: Color {
        switch self {
        case .primaryPurple: return .primaryViolet1_50
        case .secondaryPurple: return .primaryViolet1_500
        case .primaryGreen: return .secondaryGreen1_50
        case .secondaryGreen: return .secondaryGreen2_600
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primaryPurple: return .primaryViolet1_500
        case .primaryGreen: return .secondaryGreen2_600
        case .secondaryPurple, .secondaryGreen: return .clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primaryPurple, .primaryGreen: return 0
        case .secondaryPurple, .secondaryGreen: return 1
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primaryPurple, .secondaryPurple: return .primaryViolet1_500
        case .primaryGreen, .secondaryGreen: return .secondaryGreen2_600
        }
    }
}
