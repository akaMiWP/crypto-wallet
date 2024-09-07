// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct WelcomeView: View {
    
    @State private var navigationPath: NavigationPath = .init()
    
    enum Destinations {
        case createSeedPhrase
        case importSeedPhrase
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .padding()
                
                Spacer()
                
                Button(action: { navigationPath.append(Destinations.createSeedPhrase) }, label: {
                    Text("Create a seed phrase")
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 12, height: 12)))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                })
                
                Button(action: { navigationPath.append(Destinations.importSeedPhrase) }, label: {
                    Text("Import a seed phrase")
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                })
            }
            .navigationDestination(for: Destinations.self) {
                switch $0 {
                case .createSeedPhrase:
                    GenerateSeedPhraseView(
                        viewModel: .init(manageHDWalletUseCase: ManageHDWalletImpl()),
                        navigationPath: $navigationPath
                    )
                case .importSeedPhrase:
                    EnterPassPhraseView()
                }
            }
            .navigationTitle("Welcome !")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
