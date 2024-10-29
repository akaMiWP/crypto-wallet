// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Color.secondaryGreen2_600)
                
                Text("Account #1")
                    .font(.title3)
                    .fontWeight(.regular)
                
                Button(action: { viewModel.didTapEditAccount() }, label: {
                    Image(systemName: "highlighter")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.primaryViolet1_400)
                        .fontWeight(.semibold)
                })
                
                Spacer()
            }
            .padding(.leading, 36)
            
            List(viewModel.rows) { row in
                HStack {
                    row.rowType.iconName.map {
                        Image(systemName: $0)
                            .foregroundColor(.primaryViolet1_400)
                    }
                    
                    Text(row.rowType.title)
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
