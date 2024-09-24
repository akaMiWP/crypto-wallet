// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct WelcomeView: View {
    
    @Binding var navigationPath: NavigationPath
    
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
                
                PrimaryButton(
                    title: "Create a seed phrase") {
                        navigationPath.append(Destinations.createSeedPhrase)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                
                PrimaryButton(title: "Import a seed phrase", type: .secondaryGreen) {
                    navigationPath.append(Destinations.importSeedPhrase)
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                
            }
            .background(Color.primaryViolet1_900)
            .navigationDestination(for: Destinations.self) {
                switch $0 {
                case .createSeedPhrase:
                    GenerateSeedPhraseView(
                        viewModel: .init(
                            manageHDWalletUseCase: ManageHDWalletImpl(),
                            manageWalletsUseCase: ManageWalletsImpl(),
                            userDefaultUseCase: UserDefaultImp()
                        ),
                        navigationPath: $navigationPath
                    )
                    .navigationBarBackButtonHidden()
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
        WelcomeView(navigationPath: .constant(.init()))
    }
}
