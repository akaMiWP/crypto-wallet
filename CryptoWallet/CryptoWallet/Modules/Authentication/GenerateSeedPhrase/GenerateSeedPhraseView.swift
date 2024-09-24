// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var isBlurApplied: Bool = true
    
    @ObservedObject private var viewModel: GenerateSeedPhraseViewModel
    private var navigationPath: Binding<NavigationPath>
    
    enum Destinations {
        case showCongrats
    }
    
    init(viewModel: GenerateSeedPhraseViewModel, navigationPath: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self.navigationPath = navigationPath
    }
     
    var body: some View {
        VStack(spacing: 0) {
            ProgressBarView(totalSteps: 3, currentIndex: 0)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Secret Recovery Phrase")
                    .foregroundColor(.primaryViolet1_800)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                
                Text("Do not lose the seed phrase. It's necessary to receover your entire wallets")
                    .foregroundColor(.primaryViolet1_900)
                    .font(.body)
            }
            .padding(.top, 70)
            
            LazyVGrid(columns: gridItems) {
                ForEach(Array(viewModel.mnemonic.enumerated()), id: \.offset) { index, word in
                    Text("\(index + 1). \(word)")
                        .font(.caption)
                        .foregroundColor(Color.primaryViolet1_900)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryViolet1_50)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        .overlay {
                            RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                                .stroke(lineWidth: 0)
                        }
                }
                .redacted(reason: viewModel.state.redactionReasons)
            }
            .padding(.top, 60)
            .blur(radius: isBlurApplied ? 6 : 0)
            .overlay {
                if isBlurApplied {
                    Image(systemName: "eye.slash.fill")
                        .resizable()
                        .frame(width: 50, height: 40)
                }
            }
            .onTapGesture { isBlurApplied.toggle() }
            
            Spacer()
            
            PrimaryButton(title: "Continue") {
                navigationPath.wrappedValue.append(Destinations.showCongrats)
                viewModel.didTapButton()
            }
            .shadow(color: .primaryViolet2_300, radius: 22, x: 7, y: 7)
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 48)
        .modifier(AlertModifier(viewModel: viewModel))
        .modifier(CardModifier())
        .navigationDestination(for: Destinations.self) {
            switch $0 {
            case .showCongrats: CongratsView(viewModel: .init(), navigationPath: navigationPath)
            }
        }
        .onAppear {
            isBlurApplied = true
            viewModel.createSeedPhrase()
        }
    }
}

#Preview {
    NavigationStack {
        let viewModel: GenerateSeedPhraseViewModel = .init(
            manageHDWalletUseCase: ManageHDWalletImpl(),
            manageWalletsUseCase: ManageWalletsImpl(),
            userDefaultUseCase: UserDefaultImp()
        )
//        viewModel.alertViewModel = .init()
        return GenerateSeedPhraseView(viewModel: viewModel, navigationPath: .constant(.init()))
    }
}
