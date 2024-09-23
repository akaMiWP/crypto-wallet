// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

final class SelectTokensViewModel: ObservableObject {
    let viewModels: [TokenViewModel]
    
    init(viewModels: [TokenViewModel]) {
        self.viewModels = viewModels
    }
}
