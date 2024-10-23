// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

enum SettingsRowType {
    case changeTheme
    case resetWallet
    case revealSeedPhrase
    
    var title: String {
        switch self {
        case .changeTheme: return "Change Theme"
        case .resetWallet: return "Reset Wallet"
        case .revealSeedPhrase: return "Reveal Seed Phrase"
        }
    }
    
    var titleColor: Color {
        switch self {
        case .changeTheme: return Color.primaryViolet1_900
        case .resetWallet: return .red
        case .revealSeedPhrase: return Color.primaryViolet1_900
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .changeTheme: return Color.primaryViolet1_50
        case .resetWallet: return .clear
        case .revealSeedPhrase: return Color.primaryViolet1_50
        }
    }
    
    var iconName: String? {
        switch self {
        case .changeTheme: return "moon.fill"
        case .resetWallet: return nil
        case .revealSeedPhrase: return "rectangle.and.pencil.and.ellipsis"
        }
    }
}

struct SettingsRowViewModel: Identifiable {
    let id: UUID = .init()
    let rowType: SettingsRowType
}

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Color.primaryViolet1_900)
                
                Text("Account #1")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Button(action: { viewModel.didTapEditAccount() }, label: {
                    Image(systemName: "highlighter")
                        .frame(width: 44, height: 44)
                })
                
                Spacer()
            }
            
            List(viewModel.rows) { row in
                HStack {
                    Text(row.rowType.title)
                        .fontWeight(.semibold)
                    
                    row.rowType.iconName.map {
                        Image(systemName: $0)
                    }
                }
                .foregroundColor(row.rowType.titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .listRowBackground(row.rowType.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    switch row.rowType {
                    case .changeTheme: viewModel.didTapChangeTheme()
                    case .resetWallet: return
                    case .revealSeedPhrase: viewModel.didTapRevealSeedPhrase()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .modifier(AlertModifier(viewModel: viewModel))
        .alert(
            "Seed Phrase",
            isPresented: isPresented,
            actions: {},
            message: {
                viewModel.mneumonic.map {
                    Text($0)
                }
            }
        )
    }
}

// MARK: - Private
private extension SettingsView {
    var isPresented: Binding<Bool> {
        .init(
            get: { viewModel.mneumonic != nil },
            set: { isPresented in
                if !isPresented { viewModel.mneumonic = nil }
            }
        )
    }
}

#Preview {
    SettingsView(viewModel: .init(manageHDWalletUseCase: ManageHDWalletImpl()))
}
