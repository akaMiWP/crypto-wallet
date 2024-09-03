// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokensView: View {
    @State private var searchInput: String = ""
    
    var body: some View {
        NavigationStack {
            makeSearchComponentView()
            
            ScrollView {
                NavigationLink(value: NavigationDestinations.sendToken) {
                    TokenListView(shouldShowTotalAmount: false)
                }
                
                Spacer()
            }
            .navigationDestination(for: NavigationDestinations.self) { screen in
                switch screen {
                case .sendToken: SelectTokenView().navigationBarHidden(true)
                default: EmptyView()
                }
            }
        }
    }
}

// MARK: - Private
private extension SelectTokensView {
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
    SelectTokensView()
}
