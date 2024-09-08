// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class CongratsViewModel: ObservableObject {
    func didTapButton() {
        NotificationCenter.default.post(name: .init("isSignedIn"), object: nil)
    }
}
