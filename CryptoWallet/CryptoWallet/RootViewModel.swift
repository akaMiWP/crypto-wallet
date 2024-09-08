// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class RootViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let globalEventUseCase: GlobalEventUseCase
    private let userDefaultUseCase: UserDefaultUseCase
    
    init(globalEventUseCase: GlobalEventUseCase,
         userDefaultUseCase: UserDefaultUseCase
    ) {
        self.globalEventUseCase = globalEventUseCase
        self.userDefaultUseCase = userDefaultUseCase
        
        isSignedIn = userDefaultUseCase.retrieveHasCreatedWallet()
    }
    
    func listenToSignInEvent() {
        globalEventUseCase.makeIsSignedInPublisher()
            .sink { _ in
                self.isSignedIn = true
            }
            .store(in: &cancellables)
    }
}
