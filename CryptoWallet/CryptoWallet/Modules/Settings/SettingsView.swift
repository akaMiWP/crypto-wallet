// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Image(uiImage: .iconAvatar)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.secondaryGreen2_600)
                
                Text("Account #1")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Button(action: { viewModel.didTapEditAccount() }, label: {
                    Image(uiImage: .iconPencil)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.primaryViolet1_400)
                        .fontWeight(.semibold)
                })
                
                Spacer()
            }
            .padding(.leading, 36)
            
            List(viewModel.rows) { row in
                HStack(spacing: 10) {
                    row.rowType.iconName.map {
                        Image(uiImage: $0)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.primaryViolet1_400)
                    }
                    
                    if case .changeTheme = row.rowType {
                        Toggle(isOn: $viewModel.toggleDarkMode) {
                            Text("Change Theme")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .tint(.neutral_90)
                    } else {
                        Text(row.rowType.title)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
                .listRowSeparatorTint(.white)
                .foregroundColor(row.rowType.titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 22)
                .padding(.leading, 24)
                .padding(.trailing, 2)
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
