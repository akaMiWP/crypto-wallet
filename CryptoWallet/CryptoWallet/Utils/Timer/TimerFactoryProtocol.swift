// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

protocol TimerFactoryProtocol {
    func scheduledTimer(
        withTimeInterval interval: TimeInterval,
        repeats: Bool,
        block: @escaping (Timer) -> Void
    ) -> Timer
}

final class TimerFactory: TimerFactoryProtocol {
    
    func scheduledTimer(
        withTimeInterval interval: TimeInterval,
        repeats: Bool,
        block: @escaping (Timer) -> Void
    ) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}

