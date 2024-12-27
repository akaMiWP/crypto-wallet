// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct ContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainer = .init()
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[ContainerEnvironmentKey.self] }
        set { self[ContainerEnvironmentKey.self] = newValue }
    }
}
