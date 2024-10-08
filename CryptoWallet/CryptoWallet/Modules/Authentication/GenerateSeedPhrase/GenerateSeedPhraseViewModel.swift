// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation
import SwiftUI

final class GenerateSeedPhraseViewModel: Alertable {
    
    @Published var state: ViewModelState = .loading
    @Published var mnemonic: [String] = Array(repeating: "---", count: 12)
    @Published var alertViewModel: AlertViewModel?
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private let manageWalletsUseCase: ManageWalletsUseCase
    private var userDefaultUseCase: UserDefaultUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var manageHDWalletPublisher = manageHDWalletUseCase
        .createHDWalletPublisher(strength: 128)
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase,
         manageWalletsUseCase: ManageWalletsUseCase,
         userDefaultUseCase: UserDefaultUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
        self.manageWalletsUseCase = manageWalletsUseCase
        self.userDefaultUseCase = userDefaultUseCase
    }
    
    func createSeedPhrase() {
        manageHDWalletPublisher
            .map { $0.split(separator: " ").map { String($0) } }
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    self.alertViewModel = .init(message: error.localizedDescription)
                    self.state = .error
                } else {
                    self.state = .finished
                }
            }, receiveValue: {
                self.mnemonic = $0
            })
            .store(in: &cancellables)
    }
    
    func didTapCopyButton() {
        UIPasteboard.general.string = mnemonic.joined(separator: " ")
    }
    
    func didTapButton() {
        let mnemonic = String(mnemonic.joined(separator: " "))
        manageHDWalletUseCase
            .encryptMnemonic(mnemonic)
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self = self else { return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
                return self.manageHDWalletUseCase.deletePreviousCreatedWalletModelsIfNeeded()
            }
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self = self else { return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
                return self.manageWalletsUseCase.makeNewWalletModel(coinType: .ethereum)
            }
            .catch { error in
                self.alertViewModel = .init(message: error.localizedDescription)
                return Just(()).eraseToAnyPublisher()
            }
            .sink { [weak self] output in
                self?.userDefaultUseCase.setHasCreatedWallet(true)
            }
            .store(in: &cancellables)
    }
}
