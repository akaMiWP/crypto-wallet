// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

enum ViewModelState {
    case loading
    case finished
    case error
}

extension ViewModelState {
    var redactionReasons: RedactionReasons {
        switch self {
        case .loading, .error: return .placeholder
        case .finished: return []
        }
    }
    
    var isLoading: Bool { self == .loading }
}
