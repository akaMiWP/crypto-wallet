// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import LocalAuthentication

final class BiometricViewModel: ObservableObject {
    
    // Input properties
    @Published var passwordInput: String = ""
    @Published var allowPasswordInput: Bool = false
    let tap: PassthroughSubject<Void, Never> = .init()
    
    // Output properties
    @Published var isPolicyEvaluated: Bool = false
    
    private let authenticateUseCase: AuthenticateUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authenticateUseCase: AuthenticateUseCase) {
        self.authenticateUseCase = authenticateUseCase
        
        Publishers.CombineLatest(tap, $passwordInput)
            .flatMap { [weak self] (_, password) in
                guard let self = self else { return Empty<Bool, Error>().eraseToAnyPublisher() }
                return self.authenticateUseCase.validateWithPassword(password)
            }
            .catch { error in
                print("Error found:", error.localizedDescription)
                return Just(false)
            }
            .assign(to: &$isPolicyEvaluated)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isPolicyEvaluated = success
                }
            }
        } else {
            allowPasswordInput = true
        }
    }
}
