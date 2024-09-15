// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation
import SwiftUI

final class GenerateSeedPhraseViewModel: Alertable {
    
    @Published var state: ViewModelState = .loading
    @Published var mnemonic: [String] = Array(repeating: "---", count: 12)
    @Published var alertViewModel: AlertViewModel?
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private var userDefaultUseCase: UserDefaultUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var manageHDWalletPublisher = manageHDWalletUseCase
        .createHDWalletPublisher(strength: 128)
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase, userDefaultUseCase: UserDefaultUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
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
    
    func didTapButton() {
        userDefaultUseCase.setHasCreatedWallet(true)
        do {
            let mnemonic = String(mnemonic.flatMap { $0 })
            try manageHDWalletUseCase.encryptMnemonic(mnemonic)
        } catch {
            alertViewModel = .init(message: error.localizedDescription)
        }
    }
}