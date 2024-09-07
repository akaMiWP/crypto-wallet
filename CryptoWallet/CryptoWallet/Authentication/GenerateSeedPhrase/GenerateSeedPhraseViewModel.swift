// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation
import SwiftUI

final class GenerateSeedPhraseViewModel: ObservableObject {
    
    @Published var mnemonic: [String] = Array(repeating: "", count: 12)
    @Published var error: Error?
    
    var showAlert: Binding<Bool> {
        .init(
            get: { self.error != nil },
            set: { newValue in
                if !newValue {
                    self.error = nil
                }
            }
        )
    }
    
    private let manageHDWalletUseCase: ManageHDWalletUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var manageHDWalletPublisher = manageHDWalletUseCase
        .createHDWalletPublisher(strength: 128)
    
    init(manageHDWalletUseCase: ManageHDWalletUseCase) {
        self.manageHDWalletUseCase = manageHDWalletUseCase
    }
    
    func createSeedPhrase() {
        manageHDWalletPublisher
            .map { $0.split(separator: " ").map { String($0) } }
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    self.error = error
                }
            }, receiveValue: {
                self.mnemonic = $0
            })
            .store(in: &cancellables)
    }
}
