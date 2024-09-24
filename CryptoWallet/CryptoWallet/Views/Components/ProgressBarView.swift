// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ProgressBarView: View {
    private let totalSteps: Int
    private let currentIndex: Int
    
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
    func makeBarColor(elementIndex: Int) -> Color {
        elementIndex == currentIndex ? Color.secondaryGreen2_600 : Color.secondaryGreen2_400
    }
}

#Preview {
    ProgressBarView(totalSteps: 3, currentIndex: 0)
}
