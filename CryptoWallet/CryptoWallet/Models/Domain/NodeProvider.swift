// Copyright © 2567 BE akaMiWP. All rights reserved.

import Foundation

enum NodeProvider {
    case ethereum
    case zksync
    case arbitrum
    case optimism
    case sepolia
    
    var url: String? {
        switch self {
        case .ethereum: return Bundle.main.object(forInfoDictionaryKey: "NODE_ETHEREUM_URL") as? String
        case .zksync: return Bundle.main.object(forInfoDictionaryKey: "NODE_ZKSYNC_URL") as? String
        case .arbitrum: return Bundle.main.object(forInfoDictionaryKey: "NODE_ARBITRUM_URL") as? String
        case .optimism: return Bundle.main.object(forInfoDictionaryKey: "NODE_OPTIMISM_URL") as? String
        case .sepolia: return Bundle.main.object(forInfoDictionaryKey: "NODE_SEPOLIA_URL") as? String
        }
    }
}
