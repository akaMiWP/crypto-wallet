// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Create a password")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 8)
            
            Text("This is for unlock your wallet")
                .font(.body)
            
            TextField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
            
            TextField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
            
            Button(action: {}) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding()
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        GenerateSeedPhraseView()
    }
}
