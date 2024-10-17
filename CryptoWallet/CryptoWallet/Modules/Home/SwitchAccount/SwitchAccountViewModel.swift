// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

struct WalletViewModel: Equatable {
    let name: String
    let address: String
    let isSelected: Bool
    
    var maskedAddress: String { address.maskedHexString() }
    
    static let `default`: WalletViewModel = .init(name: "Account 0", address: "0x00000000", isSelected: false)
}

struct WalletModel: Codable, Equatable {
    let name: String
    let address: String
}


final class SwitchAccountViewModel: Alertable {
    
    struct ViewModel {
        let accountAddress: String
        let models: [WalletModel]
        
        static let `default`: ViewModel = .init(accountAddress: "", models: [])
    }
    
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
            .flatMap { models in
                self.manageWalletsUseCase
                    .loadSelectedWalletPublisher()
                    .map { ViewModel(accountAddress: $0.address, models: models) }
            }
            .tryCatch { [weak self] error -> AnyPublisher<ViewModel, Never> in
                self?.alertViewModel = .init(message: error.localizedDescription)
                return Just(.default).eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] viewModel in
                    self?.wallets = viewModel.models.map {
                        .init(name: $0.name, address: $0.address, isSelected: $0.address == viewModel.accountAddress)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func createNewWallet() {
        manageWalletsUseCase
            .makeNewWalletModel(coinType: .ethereum)
            .catch { [weak self] error -> AnyPublisher<Void, Never> in
                guard let self = self else { return Just(()).eraseToAnyPublisher() }
                self.alertViewModel = .init(message: error.localizedDescription)
                return Just(()).eraseToAnyPublisher()
            }
            .sink { _ in
                NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
            }
            .store(in: &cancellables)
    }
    
    func selectWallet(wallet: WalletViewModel) {
        Just(wallet)
            .flatMap { [weak self] viewModel -> AnyPublisher<Void, Error> in
                guard let self = self else { return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
                let model: WalletModel = .init(name: viewModel.name, address: viewModel.address)
                return self.manageWalletsUseCase.selectWallet(wallet: model)
            }
            .catch { [weak self] error -> AnyPublisher<Void, Never> in
                self?.alertViewModel = .init(message: error.localizedDescription)
                return Just(()).eraseToAnyPublisher()
            }
            .sink { _ in
                NotificationCenter.default.post(name: .init("accountChanged"), object: nil)
            }
            .store(in: &cancellables)
    }
}
