// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct TitleBarPresentedView<BottomView: View>: View {
    private let title: String
    private let imageSystemName: String
    private let bottomView: BottomView
    
    init(
        title: String,
        imageSystemName: String = "xmark",
        @ViewBuilder bottomView: () -> BottomView
    ) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.bottomView = bottomView()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Text(title)
                    .font(.headline)
                
                HStack {
                    Button(action: {}) {
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
