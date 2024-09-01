// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokenView: View {
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
private extension SelectTokenView {
    func makeSearchComponentView() -> some View {
        TitleBarPresentedView(title: "Select Token") {
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
    }
}

#Preview {
    SelectTokenView()
}
