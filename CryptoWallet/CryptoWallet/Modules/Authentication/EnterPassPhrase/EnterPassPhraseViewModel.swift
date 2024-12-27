// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class EnterPassPhraseViewModel: ObservableObject, Alertable {
    // Inputs
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    let tap: PassthroughSubject<Void, Error> = .init()
    
    // Outputs
    @Published var validationPasswordLength: Bool = false
    @Published var validationContainNumberOrSymbol: Bool = false
    @Published var validationSuccess: Bool = false
    @Published var alertViewModel: AlertViewModel?
    let onSave: PassthroughSubject<Void, Never> = .init()
    
    private let keychainManager: KeychainManager
    private let passwordRepository: PasswordRepository
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(keychainManager: KeychainManager = .shared, passwordRepository: PasswordRepository) {
        self.keychainManager = keychainManager
        self.passwordRepository = passwordRepository
        
        let publisher = Publishers
            .CombineLatest($password, $confirmPassword)
        
        publisher
            .map { password, confirmPassword in
                return password.count >= 8 && confirmPassword.count >= 8 && password.count == confirmPassword.count
            }
            .assign(to: &$validationPasswordLength)
        
        publisher
            .map { password, confirmPassword in
                let rules = CharacterSet.decimalDigits.union(.symbols).union(.punctuationCharacters)
                return password.rangeOfCharacter(from: rules) != nil && password == confirmPassword
            }
            .assign(to: &$validationContainNumberOrSymbol)
        
        Publishers
            .CombineLatest($validationPasswordLength, $validationContainNumberOrSymbol)
            .map { passwordLenghth, numberOrSymbol in passwordLenghth && numberOrSymbol }
            .assign(to: &$validationSuccess)
        
        tap
//            .flatMap { [weak self] in
//                guard let self = self else { return Fail<Void, Error>(error: NSError(domain: "", code: 0)).eraseToAnyPublisher() }
//                //TODO: Use repository to store it and let GenerateSeedPhraseViewModel store the password
//                return Future { promise in
//                    do {
//                        try self.keychainManager.set(self.password, for: .password)
//                        promise(.success(()))
//                    } catch {
//                        promise(.failure(error))
//                    }
//                }.eraseToAnyPublisher()
//            }
//            .catch { [weak self] error in
//                print("Error:", error.localizedDescription)
//                self?.alertViewModel = .init()
//                return Empty<Void, Never>().eraseToAnyPublisher()
//            }
            .handleEvents(receiveOutput: { [weak self] in
                guard let self = self else { return }
                self.passwordRepository.set(password: password)
            })
            .sink(receiveCompletion: { [weak self] _ in
                self?.onSave.send()
            }, receiveValue: {})
            .store(in: &cancellables)
    }
}
