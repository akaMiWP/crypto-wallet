// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import LocalAuthentication

final class BiometricViewModel: ObservableObject {
    
    @Published var isPolicyEvaluated: Bool = false
    
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
            //TODO: Ask a user for password
        }
    }
    
    func makeDashboardViewModel() -> DashboardViewModel {
        .init(
            nodeProviderUseCase: NodeProviderImpl(
                networkStack: .init(),
                networkPollingHandler: NetworkPollingHandler()
            ),
            manageHDWalletUseCase: ManageHDWalletImpl(),
            manageTokensUseCase: ManageTokensImp(),
            manageWalletsUseCase: ManageWalletsImpl(),
            supportNetworksUseCase: SupportNetworksImp(),
            globalEventUseCase: GlobalEventImp()
        )
    }
}
