// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SendView: View {
    @State private var searchInput: String = ""
    
    var body: some View {
        makeSearchComponentView()
        
        ScrollView {
            TokenListView(shouldShowTotalAmount: false)
            
            Spacer()
        }
    }
}

// MARK: - Private
private extension SendView {
    func makeSearchComponentView() -> some View {
        VStack(spacing: 24) {
            ZStack {
                Text("Select Token")
                    .font(.headline)
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchInput)
                }
                .padding(.all, 8)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                
                Text("Cancel")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
    }
}

#Preview {
    SendView()
}
