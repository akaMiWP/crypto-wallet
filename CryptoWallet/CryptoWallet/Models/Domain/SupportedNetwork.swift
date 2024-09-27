// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

enum TestNetwork {
    case sepolia
    
    var network: CoinType {
        switch self {
        case .sepolia: return .ethereum
        }
    }
}

enum MainnetNetwork: CaseIterable {
    case ethereum
    case zksync
    case arbitrum
    case optimism
    
    var network: CoinType {
        switch self {
        case .ethereum: return .ethereum
        case .zksync: return .zksync
        case .arbitrum: return .arbitrum
        case .optimism: return .optimism
        }
    }
}

enum SupportedNetwork: Hashable {
    case testnet(TestNetwork)
    case mainnet(MainnetNetwork)
}
