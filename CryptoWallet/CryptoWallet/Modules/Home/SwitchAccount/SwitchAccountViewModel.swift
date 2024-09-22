// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

struct WalletViewModel: Equatable {
    let name: String
    let address: String
    let isSelected: Bool
}

struct WalletModel: Codable, Equatable {
    let name: String
    let address: String
}

final class SwitchAccountViewModel: Alertable {
    
    @Published var wallets: [WalletViewModel] = []
    @Published var alertViewModel: AlertViewModel?
    
    private let manageWalletsUseCase: ManageWalletsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(manageWalletsUseCase: ManageWalletsUseCase) {
        self.manageWalletsUseCase = manageWalletsUseCase
    }
    
    func loadWallets() {
        manageWalletsUseCase
            .loadWalletsPublisher()
            .tryCatch { [weak self] error -> AnyPublisher<[WalletModel], Never> in
                self?.alertViewModel = .init(message: error.localizedDescription)
                return Just([]).eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] models in
                    self?.wallets = models.map { .init(name: $0.name, address: $0.address, isSelected: false) }
                }
            )
            .store(in: &cancellables)
    }
    
    func createNewWallet() {
        do {
            try manageWalletsUseCase.makeNewWalletModel(coinType: .ethereum)
            NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
        } catch {
            alertViewModel = .init(message: error.localizedDescription)
        }
    }
    
    func selectWallet(wallet: WalletViewModel) {
        NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
    }
}
