// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ToastMessageModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        content
            .overlay { ToastMesssageView(text: text) }
    }
}
