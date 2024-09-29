// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol Alertable: ObservableObject {
    var alertViewModel: AlertViewModel? { get set }
}
