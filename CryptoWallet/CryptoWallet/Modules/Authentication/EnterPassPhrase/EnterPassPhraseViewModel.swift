// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

final class EnterPassPhraseViewModel: ObservableObject {
    // Inputs
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // Outputs
    @Published var validationPasswordLength: Bool = false
    @Published var validationContainNumberOrSymbol: Bool = false
    @Published var validationSuccess: Bool = false
    
    init() {
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
    }
}
