// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TitleBarPresentedView<BottomView: View>: View {
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
                    .foregroundColor(.primaryViolet1_50)
                
                HStack {
                    Button(action: { backCompletion?() }) {
                        Image(systemName: imageSystemName)
                            .foregroundColor(.primaryViolet1_50)
                    }
                    Spacer()
                }
            }
            
            bottomView
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.primaryViolet1_600, .primaryViolet1_900],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        )
    }
}

#Preview {
    TitleBarPresentedView(title: "") { EmptyView() }
}
