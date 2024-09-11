// Copyright © 2567 BE akaMiWP. All rights reserved.

struct TokenBalancesResponse: Decodable {
    let address: String
    let tokenBalances: [TokenBalanceResponse]
}

struct TokenBalanceResponse: Decodable {
    let contractAddress: String
    let tokenBalance: String
}
