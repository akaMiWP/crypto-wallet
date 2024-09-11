// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct SelectTokenView: View {
    @State private var addressInput: String = ""
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            makeTopBarComponent()
            
            makeAddressComponent()
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
            })
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerSize: .init(width: 24, height: 24)))
            .padding()
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
                
                TextField("Name or address", text: $addressInput)
                    .font(.subheadline)
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
    SelectTokenView(navigationPath: .constant(.init()))
}
