// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct AlertModifier<ViewModel: Alertable>: ViewModifier {
    @ObservedObject var viewModel: ViewModel
    
    func body(content: Content) -> some View {
        content
            .alert(
                viewModel.alertViewModel?.title ?? "",
                isPresented: isPresented,
                presenting: viewModel.alertViewModel,
                actions: { _ in
                    Button("Ok") {
                        viewModel.alertViewModel?.dismissAction?()
                    }
                },
                message: { viewModel in
                    Text(viewModel.message)
                }
            )
    }
}

//MARK: - Private
private extension AlertModifier {
    var isPresented: Binding<Bool> {
        .init(
            get: { viewModel.alertViewModel != nil },
            set: { newValue in
                if !newValue {
                    viewModel.alertViewModel = nil
                }
            }
        )
    }
}
