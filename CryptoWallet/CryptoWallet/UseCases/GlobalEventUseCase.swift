// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

protocol GlobalEventUseCase {
    func makeIsSignedInPublisher() -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure>
}

final class GlobalEventImp: GlobalEventUseCase {
    
    func makeIsSignedInPublisher() -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        NotificationCenter.default.publisher(for: .init("isSignedIn"))
            .eraseToAnyPublisher()
    }
}