// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokenView: View {
    @ObservedObject var viewModel: SelectTokenViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            makeAddressComponent()
            
            Spacer()
            
            Button(action: viewModel.didTapNextButton, label: {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
            })
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(viewModel.isAddressValid ? Color.primaryViolet1_400 : Color.primaryViolet1_100)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
            .padding()
            .disabled(!viewModel.isAddressValid)
        }
    }
}

// MARK: - Private
private extension SelectTokenView {
    func makeTopBarComponent() -> some View {
        TitleBarPresentedView(
            title: "Send $ETH",
            imageSystemName: "chevron.backward",
            bottomView: { EmptyView() },
            backCompletion: {
                navigationPath.removeLast()
            }
        )
    }
    
    func makeAddressComponent() -> some View {
        VStack {
            HStack {
                Text("To:")
                    .font(.headline)
                
                TextField("Name or address", text: $viewModel.addressInput)
                    .font(.subheadline)
                
                Image(systemName: "doc.on.clipboard.fill")
                    .resizable()
                    .foregroundColor(.primaryViolet1_800)
                    .frame(width: 20, height: 20)
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        let address = UIPasteboard.general.string
                        viewModel.didTapPasteButton(address: address)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Rectangle()
                .fill(.gray.opacity(0.2))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SelectTokenView(
        viewModel: .init(prepareTransactionUseCase: PrepareTransactionImp()),
        navigationPath: .constant(.init())
    )
}
