// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol AuthenticateUseCase: AnyObject {
    func validateWithPassword(_ password: String) -> AnyPublisher<Bool, Error>
}

final class AuthenticateImp: AuthenticateUseCase {
    
    private let keychain: KeychainManager
    
    init(keychain: KeychainManager = .shared) {
        self.keychain = keychain
    }
    
    func validateWithPassword(_ password: String) -> AnyPublisher<Bool, Error> {
        guard let storedPassword = try? keychain.get(String.self, for: .password) else {
            return Fail(error: AuthenticateError.unableToRetrievePassword).eraseToAnyPublisher()
        }
        let result = password == storedPassword
        return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum AuthenticateError: Error {
    case unableToRetrievePassword
}
