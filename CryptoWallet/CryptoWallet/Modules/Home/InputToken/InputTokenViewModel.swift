// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class InputTokenViewModel: ObservableObject {
    
    @Published var inputAmount: String = ""
    
    let selectedTokenViewModel: TokenViewModel
    let selectedDestinationAddress: String
    let title: String
    
    init(selectedTokenViewModel: TokenViewModel,
         selectedDestinationAddress: String,
         title: String
    ) {
        self.selectedTokenViewModel = selectedTokenViewModel
        self.selectedDestinationAddress = selectedDestinationAddress
        self.title = title
    }
}
