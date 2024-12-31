// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class TransactionReceiptViewModel: ObservableObject, Alertable {
    enum ReceiptViewState: Equatable {
        case initiatingTransaction
        case processingTransaction
        case confirmedTransaction(txHash: String)
    }
    
    // Input
    let tapLink: PassthroughSubject<Void, Error> = .init()
    
    // Output
    @Published var viewState: ReceiptViewState = .initiatingTransaction
    @Published var url: URL?
    @Published var alertViewModel: AlertViewModel?
    
    private let chainExplorerUseCase: ChainExplorerUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(chainExplorerUseCase: ChainExplorerUseCase) {
        self.chainExplorerUseCase = chainExplorerUseCase
    }
    
    func fetchURL() {
        tapLink
            .flatMap { [weak self] in
                guard let self = self else {
                    return Fail<String, Error>(error: TransactionReceiptViewModelError.selfNotFound).eraseToAnyPublisher()
                }
                guard let txHash = self.viewState.txHash else {
                    return Fail<String, Error>(error: TransactionReceiptViewModelError.txHashNotFound).eraseToAnyPublisher()
                }
                return Just(txHash).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .flatMap { [weak self] txHash in
                guard let self = self else {
                    return Fail<URL, Error>(error: TransactionReceiptViewModelError.selfNotFound).eraseToAnyPublisher()
                }
                return self.chainExplorerUseCase.retrieveExplorerURL(from: txHash).eraseToAnyPublisher()
            }
            .catch { [weak self] error in
                self?.alertViewModel = .init(dismissAction: {
                    DispatchQueue.main.async {
                        self?.alertViewModel = nil
                    }
                })
                return Empty<URL, Never>().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.url = url
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension TransactionReceiptViewModel.ReceiptViewState {
    var txHash: String? {
        switch self {
        case .initiatingTransaction, .processingTransaction: return nil
        case .confirmedTransaction(let txHash): return txHash
        }
    }
}

private enum TransactionReceiptViewModelError: Error {
    case txHashNotFound
    case selfNotFound
}
