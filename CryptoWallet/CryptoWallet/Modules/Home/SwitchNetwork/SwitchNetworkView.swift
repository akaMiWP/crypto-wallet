// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct NetworkViewModel: Identifiable {
    var id: String { name }
    
    let image: UIImage?
    let name: String
}

struct SwitchNetworkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchInput: String = ""
    
    private let supportedNetworks: [NetworkViewModel] = [
        .init(image: nil, name: "Circle"),
        .init(image: nil, name: "Circle"),
        .init(image: nil, name: "Circle"),
        .init(image: nil, name: "Circle"),
        .init(image: nil, name: "Circle")
    ]
    
    var body: some View {
        VStack {
            TitleBarPresentedView(title: "Select a network") {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchInput)
                    }
                    .padding(.all, 8)
                    .foregroundColor(.primaryViolet1_900)
                    .background(Color.primaryViolet1_50)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                    
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundColor(.primaryViolet1_50)
                }
            } backCompletion: {
                dismiss()
            }
            
            ScrollView {
                ForEach(supportedNetworks) { viewModel in
                    HStack {
                        Image(systemName: "circle")
                        
                        Text(viewModel.name)
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    SwitchNetworkView()
}
