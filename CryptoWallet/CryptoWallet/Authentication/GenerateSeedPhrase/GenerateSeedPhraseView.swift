// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct GenerateSeedPhraseView: View {
    @State private var gridItems: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @ObservedObject private var viewModel: GenerateSeedPhraseViewModel
    
    init(viewModel: GenerateSeedPhraseViewModel) {
        self.viewModel = viewModel
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
                ForEach(0..<12) { index in
                    Text("Word \(index + 1)")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .border(Color.gray)
                }
                .redacted(reason: .placeholder)
            }
            .blur(radius: 6)
            .overlay {
                Image(systemName: "eye.slash.fill")
                    .resizable()
                    .frame(width: 50, height: 40)
            }
            
            Button(action: {}) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
            .padding()
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
    }
}

#Preview {
    NavigationStack {
        let viewModel: GenerateSeedPhraseViewModel = .init(manageHDWalletUseCase: ManageHDWalletImpl())
        viewModel.alertViewModel = .init()
        return GenerateSeedPhraseView(viewModel: viewModel)
    }
}
