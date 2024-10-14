// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

protocol NetworkPollingHandlerProtocol: AnyObject {
    func startPolling(
        pollingAction: @escaping (@escaping (Bool) -> Void) -> Void,
        pollingInvalidateCompletion: @escaping (Error) -> Void
    )
    func stopPolling()
}

typealias PollingActionCompletion = (@escaping (Bool) -> Void) -> Void
final class NetworkPollingHandler: NetworkPollingHandlerProtocol {
    private let pollInterval: TimeInterval
    private let timeout: TimeInterval
    private let timerFactory: TimerFactoryProtocol
    private var timer: Timer?
    private var startTime: Date?

    init(pollInterval: TimeInterval = 2.0,
         timeout: TimeInterval = 15.0,
         timerFactory: TimerFactoryProtocol = TimerFactory()
    ) {
        self.pollInterval = pollInterval
        self.timeout = timeout
        self.timerFactory = timerFactory
    }

    func startPolling(
        pollingAction: @escaping PollingActionCompletion,
        pollingInvalidateCompletion: @escaping (Error) -> Void
    ) {
        startTime = Date()
        timer = timerFactory.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if checkPollingTimeout(startTime: self.startTime) {
                let error = NetworkPollingHandlerError.pollingTimeout
                self.stopPolling()
                pollingInvalidateCompletion(error)
                return
            } else {
                pollingAction(stopPollingIfNeeded)
            }
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Private
private extension NetworkPollingHandler {
    func checkPollingTimeout(startTime: Date?) -> Bool {
        guard let startTime = startTime else { return false }
        return Date().timeIntervalSince(startTime) > self.timeout
    }
    
    func stopPollingIfNeeded(shouldStopPolling: Bool) {
        guard shouldStopPolling else { return }
        stopPolling()
    }
}

private enum NetworkPollingHandlerError: Error, LocalizedError {
    case pollingTimeout
    
    var errorDescription: String? { "Polling Timeout !" }
}
