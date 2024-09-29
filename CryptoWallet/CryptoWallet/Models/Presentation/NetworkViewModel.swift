// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct NetworkViewModel: Identifiable {
    var id: String { name }
    
    let image: UIImage
    let name: String
    let chainId: String
    let isSelected: Bool
    
    init(name: String, chainId: String, isSelected: Bool = false) {
        self.name = name
        self.chainId = chainId
        self.isSelected = isSelected
        
        switch chainId {
        case ChainIdConstants.ethereum: self.image = .iconEthereum
        case ChainIdConstants.arbitrumOne: self.image = .iconArbitrum
        case ChainIdConstants.zkSync: self.image = .iconZksync
        case ChainIdConstants.optimism: self.image = .iconOptimism
        default: self.image = .init()
        }
    }
}

struct NetworkSection {
    let title: String
    let viewModels: [NetworkViewModel]
}

struct SupportedNetworkViewModel {
    let sections: [NetworkSection]
    
    init(mainnetViewModels: [NetworkViewModel], testnetViewModels: [NetworkViewModel]) {
        self.sections = [
            .init(title: "Mainnet networks".uppercased(), viewModels: mainnetViewModels),
            .init(title: "Testnet networks".uppercased(), viewModels: testnetViewModels)
        ]
    }
    
    init(sections: [NetworkSection]) {
        self.sections = sections
    }
}
