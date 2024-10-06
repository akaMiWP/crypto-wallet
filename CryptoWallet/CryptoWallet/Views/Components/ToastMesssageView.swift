// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ToastMesssageView: View {
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
            .background(Color.secondaryGreen2_600)
            .cornerRadius(20)
            .padding(.horizontal)
            .shadow(color: Color.secondaryGreen1_300,radius: 8, y: 10)
            
            Spacer()
        }
    }
}

struct ToastMessageModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        content
            .overlay { ToastMesssageView(text: text) }
    }
}

#Preview {
    ToastMesssageView(text: "Address Copied!")
}
