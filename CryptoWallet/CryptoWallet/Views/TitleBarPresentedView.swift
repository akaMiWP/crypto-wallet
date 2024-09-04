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
                
                HStack {
                    Button(action: { backCompletion?() }) {
                        Image(systemName: imageSystemName)
                    }
                    Spacer()
                }
            }
            
            bottomView
        }
        .padding()
        .background(Color.blue.opacity(0.1))
    }
}

#Preview {
    TitleBarPresentedView(title: "") { EmptyView() }
}
