// Copyright © 2567 BE akaMiWP. All rights reserved.

import SwiftUI

struct NetworkViewModel: Identifiable, Equatable {
    var id: String { name }
    
    let image: UIImage
    let name: String
    let chainId: String
    let isSelected: Bool
    let isMainnet: Bool
    
    static let `default`: NetworkViewModel = .init(name: "", chainId: "")
    
    init(name: String, chainId: String, isSelected: Bool = false, isMainnet: Bool = true) {
        self.name = name
        self.chainId = chainId
        self.isSelected = isSelected
        self.isMainnet = isMainnet
        
        switch chainId {
        case ChainIdConstants.ethereum: self.image = .iconEthereum
        case ChainIdConstants.arbitrumOne: self.image = .iconArbitrum
        case ChainIdConstants.zkSync: self.image = .iconZksync
        case ChainIdConstants.optimism: self.image = .iconOptimism
        case ChainIdConstants.sepolia: self.image = .iconSepolia
        default: self.image = .init()
        }
    }
}

struct NetworkSection: Equatable {
    let title: String
    let viewModels: [NetworkViewModel]
}

struct SupportedNetworkViewModel: Equatable {
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
