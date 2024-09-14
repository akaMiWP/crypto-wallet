// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

protocol Alertable: ObservableObject {
    var showAlert: Bool { get set }
    var alertViewModel: AlertViewModel? { get set }
}

struct AlertModifier<ViewModel: Alertable>: ViewModifier {
    @ObservedObject var viewModel: ViewModel
    
    func body(content: Content) -> some View {
        content
            .alert(
            viewModel.alertViewModel?.title ?? "",
            isPresented: isPresented,
            presenting: viewModel.alertViewModel,
            actions: { _ in },
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
            get: { viewModel.showAlert},
            set: { newValue in
                if !newValue {
                    viewModel.showAlert = false
                }
            }
        )
    }
}
