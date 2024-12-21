// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TitleBarPresentedView<BottomView: View>: View {
    @EnvironmentObject private var theme: ThemeManager
    
    private let title: String
    private let imageSystemName: String
    private let bottomView: BottomView
    private var backCompletion: (() -> Void)?
    
    init(
        title: String,
        imageSystemName: String = "xmark",
        @ViewBuilder bottomView: () -> BottomView,
        backCompletion: (() -> Void)? = nil
    ) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.bottomView = bottomView()
        self.backCompletion = backCompletion
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(foregroundColor)
                
                HStack {
                    Button(action: { backCompletion?() }) {
                        Image(systemName: imageSystemName)
                            .foregroundColor(.primaryViolet1_400)
                    }
                    Spacer()
                }
            }
            
            bottomView
        }
        .padding()
        .background(backgroundColor)
        .sheetDropShadow()
    }
}

// MARK: - Private
private extension TitleBarPresentedView {
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_20 : .primaryViolet1_800
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
}

#Preview {
    TitleBarPresentedView(title: "") { EmptyView() }
        .environmentObject(ThemeManager())
}
