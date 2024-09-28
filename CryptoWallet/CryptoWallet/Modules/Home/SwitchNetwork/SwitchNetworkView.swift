// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct NetworkViewModel: Identifiable {
    var id: String { name }
    
    let image: UIImage?
    let name: String
    let isSelected: Bool
    
    init(image: UIImage? = nil, name: String, isSelected: Bool = false) {
        self.image = image
        self.name = name
        self.isSelected = isSelected
    }
}

struct SwitchNetworkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchInput: String = ""
    
    private let supportedNetworks: [NetworkViewModel] = [
        .init(name: "Circle"),
        .init(name: "Circle", isSelected: true),
        .init(name: "Circle"),
        .init(name: "Circle"),
        .init(name: "Circle")
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
                    HStack(spacing: 18) {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        Text(viewModel.name)
                            .font(.headline)
                            .foregroundColor(.primaryViolet1_900)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(viewModel.isSelected ? Color.primaryViolet2_50 : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(viewModel.isSelected ? overlayRoundedRectangle : nil)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SwitchNetworkView()
}

// MARK: - Private
private extension SwitchNetworkView {
    var overlayRoundedRectangle: some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.primaryViolet1_200)
                .frame(width: 10)
            
            Spacer()
        }
    }
}
