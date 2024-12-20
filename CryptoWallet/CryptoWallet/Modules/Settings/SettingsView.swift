// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var theme: ThemeManager
    
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
                    .foregroundColor(fontColor)
                
                Button(action: { viewModel.didTapEditAccount() }, label: {
                    Image(uiImage: .iconPencil)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .tint(iconColor)
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
                            .foregroundColor(iconColor)
                    }
                    
                    if case .changeTheme = row.rowType {
                        Toggle(isOn: theme.isOn) {
                            Text("Change Theme")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(fontColor)
                        }
                        .tint(.neutral_90)
                    } else {
                        Text(row.rowType.title)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                }
                .listRowSeparatorTint(listRowSeparatorColor)
                .foregroundColor(fontColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 22)
                .padding(.leading, 24)
                .padding(.trailing, 2)
                .listRowBackground(listRowBackgroundColor)
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
        .background { backgroundColor.ignoresSafeArea() }
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
    
    var fontColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var iconColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_400 : .primaryViolet1_200
    }
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .white : .primaryViolet1_700
    }
    
    var listRowBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_800
    }
    
    var listRowSeparatorColor: Color {
        theme.currentTheme == .light ? .white : .primaryViolet1_500
    }
}

#Preview {
    SettingsView(viewModel: .init(manageHDWalletUseCase: ManageHDWalletImpl()))
}
