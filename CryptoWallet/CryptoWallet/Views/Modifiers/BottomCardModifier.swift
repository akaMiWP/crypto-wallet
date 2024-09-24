// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct BottomCardModifier<InjectedView: View>: ViewModifier {
    
    @Binding var isVisible: Bool
    let injectedView: InjectedView
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isVisible {
                Color.black.opacity(0.4)
                    .blur(radius: 1)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isVisible = false
                        }
                    }
            }
            
            if isVisible {
                VStack {
                    Spacer()
                    
                    injectedView
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 48)
                        .padding(.top, 12)
                        .background {
                            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 25)
                                .fill(.white)
                                .ignoresSafeArea()
                        }
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { value in
                                    if value.translation.height > 40 {
                                        withAnimation {
                                            isVisible = false
                                        }
                                    }
                                }
                        )
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeOut, value: isVisible)
    }
}

#Preview {
    Color.primaryViolet1_900
        .ignoresSafeArea()
        .modifier(BottomCardModifier(isVisible: .constant(true), injectedView: Text("Hello")))
}
