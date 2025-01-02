// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

struct NetworkModel {
    let chainName: String
    let chainId: String
    let coinType: CoinType
    let isSelected: Bool
    let isMainnet: Bool
}

struct NetworkModels {
    let mainnets: [NetworkModel]
    let testnets: [NetworkModel]
}
