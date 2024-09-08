// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
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
        VStack {
            Text("Secret Recovery Phrase")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 8)
            
            Text("Do not lose the seed phrase. It's necessary to receover your entire wallets")
                .font(.body)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.mnemonic, id: \.self) {
                    Text($0)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .border(Color.gray)
                }
                .redacted(reason: viewModel.state.redactionReasons)
            }
            .blur(radius: isBlurApplied ? 6 : 0)
            .overlay {
                if isBlurApplied {
                    Image(systemName: "eye.slash.fill")
                        .resizable()
                        .frame(width: 50, height: 40)
                }
            }
            .onTapGesture { isBlurApplied.toggle() }
            
            Button(action: {
                navigationPath.wrappedValue.append(Destinations.showCongrats)
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
                    .padding()
            }
        }
        .padding(.horizontal)
        .alert(
            viewModel.alertViewModel?.title ?? "",
            isPresented: viewModel.showAlert,
            presenting: viewModel.alertViewModel,
            actions: { _ in },
            message: { viewModel in
                Text(viewModel.message)
            }
        )
        .navigationDestination(for: Destinations.self) {
            switch $0 {
            case .showCongrats: CongratsView(navigationPath: navigationPath)
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
        let viewModel: GenerateSeedPhraseViewModel = .init(manageHDWalletUseCase: ManageHDWalletImpl())
        viewModel.alertViewModel = .init()
        return GenerateSeedPhraseView(viewModel: viewModel, navigationPath: .constant(.init()))
    }
}
