// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ProgressBarView: View {
    private let totalSteps: Int
    private let currentIndex: Int
    
    @EnvironmentObject private var theme: ThemeManager
    
    init(totalSteps: Int = 1, currentIndex: Int = 0) {
        self.totalSteps = totalSteps
        self.currentIndex = currentIndex
    }
    
    var body: some View {
        HStack {
            ForEach(0..<totalSteps) { index in
                Rectangle()
                    .fill(makeBarColor(elementIndex: index))
                    .frame(width: 36, height: 8)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            }
        }
    }
}

// MARK: - Private
private extension ProgressBarView {
    
    var selectedBarColor: Color {
        theme.currentTheme == .light ? .secondaryGreen2_600 : .secondaryGreen2_700
    }
    
    var unselectedBarColor: Color { .secondaryGreen2_400 }
    
    func makeBarColor(elementIndex: Int) -> Color {
        elementIndex == currentIndex ? selectedBarColor : unselectedBarColor
    }
}

#Preview {
    ProgressBarView(totalSteps: 3, currentIndex: 0)
}
