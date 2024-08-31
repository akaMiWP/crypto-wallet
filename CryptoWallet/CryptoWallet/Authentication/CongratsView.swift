// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct CongratsView: View {
    var body: some View {
        VStack {
            
            Rectangle()
                .frame(height: 200)
                .padding(.horizontal)
            
            Text("You're all done!")
                .font(.title)
                .padding(.top, 16)
            
            Text("You can now fully enjoy your wallet")
                .font(.body)
                .padding(.top, 8)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
            })
            .frame(height: 46)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding(.horizontal)
            .padding(.top, 24)
        }
    }
}

#Preview {
    CongratsView()
}
