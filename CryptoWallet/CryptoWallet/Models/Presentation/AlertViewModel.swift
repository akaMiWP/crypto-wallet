// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

struct AlertViewModel {
    let title: String
    let message: String
    let dismissAction: (() -> Void)?
    
    init(title: String = "Error",
         message: String = "Something went wrong !\n Please try again",
         dismissAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.dismissAction = dismissAction
    }
}
