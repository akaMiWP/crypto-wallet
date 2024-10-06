// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchNetworkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: SwitchNetworkViewModel = .init(supportNetworksUseCase: SupportNetworksImp())
    
    var body: some View {
        VStack(spacing: 0) {
            TitleBarPresentedView(title: "Select a network") {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $viewModel.searchInput)
                    }
                    .padding(.all, 8)
                    .foregroundColor(.primaryViolet1_900)
                    .background(Color.primaryViolet1_50)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                    
                    if !viewModel.searchInput.isEmpty {
                        Text("Cancel")
                            .font(.subheadline)
                            .foregroundColor(.primaryViolet1_50)
                    }
                }
                .animation(.bouncy, value: viewModel.searchInput)
            } backCompletion: {
                dismiss()
            }
            
            List {
                ForEach(viewModel.filteredViewModels.sections, id: \.title) { section in
                    if !section.viewModels.isEmpty {
                        Section(section.title) {
                            ForEach(section.viewModels) { viewModel in
                                HStack(spacing: 18) {
                                    Image(uiImage: viewModel.image)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    
                                    Text(viewModel.name)
                                        .font(.headline)
                                        .foregroundColor(.primaryViolet1_900)
                                }
                                .listRowBackground(viewModel.isSelected ? Color.primaryViolet2_100: nil)
                                .onTapGesture {
                                    self.viewModel.didSelect(viewModel: viewModel)
                                }
                            }
                        }
                    }
                }
            }
            .animation(.linear, value: viewModel.filteredViewModels)
        }
        .modifier(AlertModifier(viewModel: viewModel))
        .onReceive(viewModel.shouldDismissSubject) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .onAppear {
            viewModel.fetchSupportedNetworks()
        }
    }
}

#Preview {
    let viewModel: SwitchNetworkViewModel = .init(supportNetworksUseCase: SupportNetworksImp())
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
