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
            .background {
                Image(.imageBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }
            .navigationDestination(for: Destinations.self) {
                switch $0 {
                case .createSeedPhrase:
                    EnterPassPhraseView(navigationPath: $navigationPath, viewModel: .init())
                    .navigationBarBackButtonHidden()
                case .importSeedPhrase:
                    EnterPassPhraseView(navigationPath: $navigationPath, viewModel: .init())
                }
            }
        }
    }
}

#Preview {
    WelcomeView(navigationPath: .constant(.init()))
}
