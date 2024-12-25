// Copyright © 2567 BE akaMiWP. All rights reserved.

import UIKit

private var screenBounds: CGRect {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return .zero
    }
    return windowScene.screen.bounds
}

var screenWidth: CGFloat { screenBounds.width }
var screenHeight: CGFloat { screenBounds.height }
