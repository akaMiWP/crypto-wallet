// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchNetworkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: SwitchNetworkViewModel
    @State private var searchInput: String = ""
    
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
                ForEach(viewModel.supportedNetworks) { viewModel in
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
                    .background(viewModel.isSelected ? Color.secondaryGreen2_100 : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(viewModel.isSelected ? overlayRoundedRectangle : nil)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchSupportedNetworks()
        }
    }
}

#Preview {
    let viewModel: SwitchNetworkViewModel = .init(supportNetworksUseCase: SupportedNetworkImp())
    viewModel.supportedNetworks = [
        .init(name: "Ethereum", isSelected: true),
        .init(name: "Zksync", isSelected: false),
    ]
    return SwitchNetworkView(viewModel: viewModel)
}

// MARK: - Private
private extension SwitchNetworkView {
    var overlayRoundedRectangle: some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondaryGreen2_600)
                .frame(width: 10)
            
            Spacer()
        }
    }
}
