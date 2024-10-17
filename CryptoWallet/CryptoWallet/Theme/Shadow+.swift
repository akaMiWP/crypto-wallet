// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

extension View {
    func dropShadow() -> some View {
        shadow(color: .primaryViolet2_300, radius: 22, x: 7, y: 7)
    }
    
    func lineUpperShadow() -> some View {
        shadow(color: .primaryViolet2_300, radius: 2, y: -2)
    }
    
    func lineDropShadow() -> some View {
        shadow(color: .primaryViolet2_300, radius: 2, y: 2)
    }
    
    func sheetDropShadow() -> some View {
        shadow(color: .primaryViolet1_300.opacity(0.15), radius: 30, y: 3)
    }
}
