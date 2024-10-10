// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

extension NavigationPath {
    mutating func removeLastIfNeeded() {
        if !isEmpty { removeLast() }
    }
}
