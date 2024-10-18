// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol Dismissable: ObservableObject {
    var shouldDismiss: Bool { get }
}
