// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            Text("Secret Recovery Phrase")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 8)
            
            Text("Do not lose the seed phrase. It's necessary to receover your entire wallets")
                .font(.body)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: gridItems) {
                ForEach(0..<12) { index in
                    Text("Word \(index + 1)")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .border(Color.gray)
                }
            }
            .blur(radius: 6)
            .overlay {
                Image(systemName: "eye.slash.fill")
                    .resizable()
                    .frame(width: 50, height: 40)
            }
            
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
