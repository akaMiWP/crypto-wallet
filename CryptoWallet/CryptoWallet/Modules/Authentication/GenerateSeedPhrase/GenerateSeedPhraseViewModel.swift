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
    private let userDefaultUseCase: UserDefaultUseCase
    private let passwordRepository: PasswordRepository
    private let keychainManager: KeychainManager
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var manageHDWalletPublisher = manageHDWalletUseCase
        .createHDWalletPublisher(strength: 128)
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase,
         manageWalletsUseCase: ManageWalletsUseCase,
         userDefaultUseCase: UserDefaultUseCase,
         passwordRepository: PasswordRepository,
         keychainManager: KeychainManager = .shared
    ) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
        self.manageWalletsUseCase = manageWalletsUseCase
        self.userDefaultUseCase = userDefaultUseCase
        self.passwordRepository = passwordRepository
        self.keychainManager = keychainManager
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
            .flatMap { [weak self] in
                guard let self = self else { return Fail<Void, Error>(error: NSError(domain: "", code: 0)).eraseToAnyPublisher() }
                guard let password = passwordRepository.retrievePassword() else {
                    return Fail<Void, Error>(error: GenerateSeedPhraseViewModelError.passwordNotFound).eraseToAnyPublisher()
                }
                return Future { promise in
                    do {
                        try self.keychainManager.set(password, for: .password)
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }.eraseToAnyPublisher()
            }
            .catch { error in
                self.alertViewModel = .init(message: error.localizedDescription)
                return Empty<Void, Never>()
            }
            .sink { [weak self] output in
                self?.userDefaultUseCase.setHasCreatedWallet(true)
            }
            .store(in: &cancellables)
    }
}

enum GenerateSeedPhraseViewModelError: Error {
    case passwordNotFound
}
