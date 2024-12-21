// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SwitchNetworkView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var theme: ThemeManager
    
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
                    .foregroundColor(placeholderTitleColor)
                    .background(placeholderBackgroundColor)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                    
                    if !viewModel.searchInput.isEmpty {
                        Text("Cancel")
                            .font(.subheadline)
                            .foregroundColor(buttonTitleColor)
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
                                        .foregroundColor(primaryForegroundColor)
                                }
                                .listRowBackground(viewModel.isSelected ? selectedRowBackgroundColor: unselectedRowBackgroundColor)
                                .onTapGesture {
                                    self.viewModel.didSelect(viewModel: viewModel)
                                }
                            }
                        }
                        .font(.caption)
                        .foregroundColor(secondaryForegroundColor)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .animation(.linear, value: viewModel.filteredViewModels)
        }
        .modifier(AlertModifier(viewModel: viewModel))
        .onReceive(viewModel.$shouldDismiss) { shouldDismiss in
            if shouldDismiss { dismiss() }
        }
        .onAppear {
            viewModel.fetchSupportedNetworks()
        }
    }
}

#Preview {
    let viewModel: SwitchNetworkViewModel = .init(supportNetworksUseCase: SupportNetworksImp())
    return SwitchNetworkView(viewModel: viewModel).environmentObject(ThemeManager())
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
    
    var buttonTitleColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet1_50
    }
    
    var placeholderTitleColor: Color { .primaryViolet1_200 }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var primaryForegroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var secondaryForegroundColor: Color {
        theme.currentTheme == .light ? .neutral_90 : .neutral_50
    }
    
    var selectedRowBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_100 : .primaryViolet1_900
    }
    
    var unselectedRowBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_800
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_700
    }
}
