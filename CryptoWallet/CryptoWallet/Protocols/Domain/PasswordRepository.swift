// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol PasswordRepository {
    func set(password: String)
    func retrievePassword() -> String?
}

final class PasswordRepositoryImp: PasswordRepository {
    private var password: String?
    
    func set(password: String) {
        self.password = password
    }
    
    func retrievePassword() -> String? {
        password
    }
}
