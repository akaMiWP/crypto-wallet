// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct CardModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    LinearGradient(
                        colors: [.primaryViolet1_600, .primaryViolet1_900],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    .ignoresSafeArea()
                    
                    Rectangle()
                        .fill(Color.white)
                        .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 50))
                        .edgesIgnoringSafeArea(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }
}

struct RoundedCornerShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path: UIBezierPath = .init(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: .init(
                width: radius,
                height: radius
            )
        )
        return .init(path.cgPath)
    }
}
