// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

enum SettingsRowType {
    case changeTheme
    case revealSeedPhrase
    
    var title: String {
        switch self {
        case .changeTheme: return "Change Theme"
        case .revealSeedPhrase: return "Reveal Seed Phrase"
        }
    }
    
    var iconName: String {
        switch self {
        case .changeTheme: return "moon.fill"
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
        NavigationStack {
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
                
                ForEach(viewModel.rows) { row in
                    HStack {
                        Text(row.rowType.title)
                            .fontWeight(.semibold)
                        
                        Image(systemName: row.rowType.iconName)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.primaryViolet1_50)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        switch row.rowType {
                        case .changeTheme: viewModel.didTapChangeTheme()
                        case .revealSeedPhrase: viewModel.didTapRevealSeedPhrase()
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(viewModel: .init())
}
