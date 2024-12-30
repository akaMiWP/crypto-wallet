// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import LocalAuthentication

final class BiometricViewModel: ObservableObject, Alertable {
    // Input properties
    @Published var passwordInput: String = ""
    @Published var allowPasswordInput: Bool = false
    let tap: PassthroughSubject<Void, Never> = .init()
    
    // Output properties
    @Published var isPolicyEvaluated: Bool = false
    @Published var alertViewModel: AlertViewModel?
    @Published var buttonEnabled: Bool = false
    
    private let authenticateUseCase: AuthenticateUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(authenticateUseCase: AuthenticateUseCase) {
        self.authenticateUseCase = authenticateUseCase
        
        tap
            .flatMap { [weak self] _ in
                guard let self = self else { return Empty<Bool, Error>().eraseToAnyPublisher() }
                return self.authenticateUseCase.validateWithPassword(self.passwordInput)
            }
            .handleEvents(
                receiveOutput: { [weak self] valid in
                    if !valid {
                        self?.alertViewModel = .init(
                            title: "Incorrect Password",
                            message: "Please try again",
                            dismissAction: {
                                DispatchQueue.main.async {
                                    self?.alertViewModel = nil
                                }
                            }
                        )
                    }
                })
            .catch { [weak self] error in
                print("Error found:", error.localizedDescription)
                self?.alertViewModel = .init(dismissAction: {
                    DispatchQueue.main.async {
                        self?.alertViewModel = nil
                    }
                })
                return Just(false)
            }
            .assign(to: &$isPolicyEvaluated)
        
        $passwordInput
            .map { !$0.isEmpty }
            .assign(to: &$buttonEnabled)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                guard let self = self else { return }
                if let _ = error {
                    DispatchQueue.main.async { self.allowPasswordInput = true }
                } else {
                    DispatchQueue.main.async { self.isPolicyEvaluated = success }
                }
            }
        } else {
            allowPasswordInput = true
        }
    }
}
