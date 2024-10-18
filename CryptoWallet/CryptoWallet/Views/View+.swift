// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import SwiftUI

extension View {
    func alertable<ViewModel: Alertable>(from viewModel: ViewModel) -> some View {
        modifier(AlertModifier(viewModel: viewModel))
    }
    
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func bottomCard<InjectedView: View>(isVisible: Binding<Bool>, injectedView: InjectedView) -> some View {
        modifier(
            BottomCardModifier(
                isVisible: isVisible,
                injectedView: injectedView
            )
        )
    }
    
    func dismissable<P: Publisher>(
        from publisher: P,
        dismissAction: DismissAction
    ) -> some View where P.Output == Bool, P.Failure == Never {
        self.onReceive(publisher) { shouldDismiss in
            if shouldDismiss { dismissAction() }
        }
    }
}
