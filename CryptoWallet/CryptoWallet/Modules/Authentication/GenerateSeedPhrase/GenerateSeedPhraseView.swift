// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var isBlurApplied: Bool = true
    @State private var isBottomCardVisible: Bool = false
    
    @ObservedObject private var viewModel: GenerateSeedPhraseViewModel
    @EnvironmentObject private var theme: ThemeManager
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
            HStack {
                ProgressBarView(totalSteps: 3, currentIndex: 1)
            }
            .frame(maxWidth: .infinity)
            .overlay {
                HStack {
                    Button(action: {
                        navigationPath.wrappedValue.removeLast()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(foregroundColor)
                            .frame(width: 24, height: 24)
                    })
                    
                    Spacer()
                }
            }
            .padding(.top, 24)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Secret Recovery Phrase")
                    .foregroundColor(foregroundColor)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                
                Text("Do not lose the seed phrase. It's necessary to receover your entire wallets")
                    .foregroundColor(foregroundColor)
                    .font(.callout)
            }
            .padding(.top, 70)
            
            LazyVGrid(columns: gridItems) {
                ForEach(Array(viewModel.mnemonic.enumerated()), id: \.offset) { index, word in
                    Text("\(index + 1). \(word)")
                        .font(.caption)
                        .foregroundColor(foregroundColor)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(placeholderBackgroundColor)
                        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
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
            
            HStack {
                Image(.iconCopy)
                Text("Copy")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(foregroundColor)
            }
            .padding(.top, 24)
            .onTapGesture { viewModel.didTapCopyButton() }
            
            Spacer()
            
            PrimaryButton(title: "Continue") {
                isBottomCardVisible = true
            }
            .shadow(color: shadowColor, radius: 22, x: 7, y: 7)
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 36)
        .background(backgroundColor)
        .alertable(from: viewModel)
        .cardStyle()
        .bottomCard(isVisible: $isBottomCardVisible, injectedView: bottomCardView)
        .navigationDestination(for: Destinations.self) {
            switch $0 {
            case .showCongrats:
                CongratsView(viewModel: .init(), navigationPath: navigationPath)
                    .navigationBarBackButtonHidden()
            }
        }
        .onAppear {
            isBlurApplied = true
            viewModel.createSeedPhrase()
        }
    }
}


// MARK: - Private
private extension GenerateSeedPhraseView {
    
    var backgroundColor: Color {
        theme.currentTheme == .light ? .neutral_10 : .primaryViolet1_800
    }
    
    var placeholderBackgroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_900
    }
    
    var dragHandleColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_50 : .primaryViolet1_700
    }
    
    var foregroundColor: Color {
        theme.currentTheme == .light ? .primaryViolet1_900 : .primaryViolet1_50
    }
    
    var shadowColor: Color {
        theme.currentTheme == .light ? .primaryViolet2_300 : .primaryViolet1_900.opacity(0.8)
    }
    
    @ViewBuilder
    var bottomCardView: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                .fill(dragHandleColor)
                .frame(width: 52, height: 8)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Are you sure you want to continue?")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(foregroundColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("These Secret Recovery Phases are the only way to restore your wallet. Write it down on your paper and keep it in a safe place.")
                    .font(.callout)
                    .foregroundColor(foregroundColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 20) {
                PrimaryButton(title: "Back", type: .secondaryPurple) {
                    isBottomCardVisible = false
                }
                
                PrimaryButton(title: "Continue") {
                    navigationPath.wrappedValue.append(Destinations.showCongrats)
                    viewModel.didTapButton()
                }
            }
            .padding(.horizontal)
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
        return GenerateSeedPhraseView(viewModel: viewModel, navigationPath: .constant(.init()))
    }
}
