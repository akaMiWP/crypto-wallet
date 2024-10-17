// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

enum TestNetwork: CaseIterable, Codable {
    case sepolia
    
    var coinType: CoinType {
        switch self {
        case .sepolia: return .ethereum
        }
    }
    
    var chainId: String {
        switch self {
        case .sepolia: return ChainIdConstants.sepolia
        }
    }
    
    init?(from coinType: CoinType) {
        switch coinType {
        case .ethereum: self = .sepolia
        default: return nil
        }
    }
}

enum MainnetNetwork: CaseIterable, Codable {
    case ethereum
    case zksync
    case arbitrum
    case optimism
    
    var coinType: CoinType {
        switch self {
        case .ethereum: return .ethereum
        case .zksync: return .zksync
        case .arbitrum: return .arbitrum
        case .optimism: return .optimism
        }
    }
    
    var chainId: String { coinType.chainId }
    
    init?(from coinType: CoinType) {
        switch coinType {
        case .ethereum: self = .ethereum
        case .zksync: self = .zksync
        case .arbitrum: self = .arbitrum
        case .optimism: self = .optimism
        default: return nil
        }
    }
}

enum SupportedNetwork: Codable, Hashable {
    case testnet(TestNetwork)
    case mainnet(MainnetNetwork)
    
    var chainId: String {
        switch self {
        case .testnet(let testNetwork): return testNetwork.chainId
        case .mainnet(let mainnetNetwork): return mainnetNetwork.chainId
        }
    }
    
    var coinType: CoinType {
        switch self {
        case .testnet(let testNetwork): return testNetwork.coinType
        case .mainnet(let mainnetNetwork): return mainnetNetwork.coinType
        }
    }
    
    var nodeProvider: NodeProvider {
        switch self {
        case .testnet(let testNetwork):
            switch testNetwork {
            case .sepolia: return .sepolia
            }
        case .mainnet(let mainnetNetwork):
            switch mainnetNetwork {
            case .ethereum: return .ethereum
            case .zksync: return .zksync
            case .arbitrum: return .arbitrum
            case .optimism: return .optimism
            }
        }
    }
}
