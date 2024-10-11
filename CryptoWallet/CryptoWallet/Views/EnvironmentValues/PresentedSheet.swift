// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct PresentedSheetKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var presentedSheet: Binding<Bool> {
        get { self[PresentedSheetKey.self] }
        set { self[PresentedSheetKey.self] = newValue }
    }
}

extension View {
    func presentedSheet(_ presentedSheet: Binding<Bool>) -> some View {
        environment(\.presentedSheet, presentedSheet)
    }
}
