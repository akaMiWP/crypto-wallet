// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

final class SettingsViewModel: Alertable {
    let rows: [SettingsRowViewModel] = [
        .init(rowType: .changeTheme),
        .init(rowType: .revealSeedPhrase),
        .init(rowType: .resetWallet)
    ]
    
    @Published var mneumonic: String?
    @Published var alertViewModel: AlertViewModel?
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
    }
    
    func didTapEditAccount() {}
    
    func didTapChangeTheme() {}
    
    func didTapRevealSeedPhrase() {
        manageHDWalletUseCase
            .retrieveMneumonicPublisher()
            .sink { [weak self] in
                if case .failure(let error) = $0 {
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] in
                self?.mneumonic = $0
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension SettingsViewModel {
    func handleError(_ error: Error) {
        alertViewModel = .init()
    }
}
