// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct NetworkViewModel: Identifiable {
    var id: String { name }
    
    let image: UIImage?
    let name: String
    let isSelected: Bool
    
    init(image: UIImage? = nil, name: String, isSelected: Bool = false) {
        self.image = image
        self.name = name
        self.isSelected = isSelected
    }
}
