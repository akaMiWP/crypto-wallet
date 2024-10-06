// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ToastMessageModifier: ViewModifier {
    let text: String
    let shouldShowToastMessage: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                shouldShowToastMessage ? ToastMesssageView(text: text) : nil
            }
            .animation(.bouncy, value: shouldShowToastMessage)
    }
}
