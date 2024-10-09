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
            title: viewModel.pageTitle,
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
                
                Image(systemName: viewModel.isAddressValid ? "checkmark" : "doc.on.clipboard.fill")
                    .resizable()
                    .foregroundColor( viewModel.isAddressValid ? .secondaryGreen2_700 : .primaryViolet1_800)
                    .frame(width: 20, height: 20)
                    .frame(width: 40, height: 40)
                    .disabled(viewModel.isAddressValid)
                    .animation(.bouncy, value: viewModel.isAddressValid)
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
        viewModel: .init(manageTokensUseCase: ManageTokensImp(),
                         prepareTransactionUseCase: PrepareTransactionImp(),
                         selectedTokenViewModel: .default),
        navigationPath: .constant(.init())
    )
}
