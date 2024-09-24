// Copyright © 2567 BE akaMiWP. All rights reserved.

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
}
