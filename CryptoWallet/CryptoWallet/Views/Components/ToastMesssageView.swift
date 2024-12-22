// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ToastMesssageView: View {
    @EnvironmentObject private var theme: ThemeManager
    
    let text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "info.circle")
                
                Text(text)
                    .frame(alignment:. leading)
                
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(20)
            .padding(.horizontal)
            .shadow(color: shadowColor,radius: 8, y: 10)
            
            Spacer()
        }
    }
}

 // MAKR: - Private
private extension ToastMesssageView {
    var shadowColor: Color {
        theme.currentTheme == .light ? Color.secondaryGreen2_600.opacity(0.35) : Color.primaryViolet1_900.opacity(0.8)
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? Color.secondaryGreen2_600 : Color.secondaryGreen1_700
    }
}

#Preview {
    ToastMesssageView(text: "Address Copied!")
}
