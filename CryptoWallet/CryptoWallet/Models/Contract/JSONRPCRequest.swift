// Copyright © 2567 BE akaMiWP. All rights reserved.

struct JSONRPCRequest: Encodable {
    let id: Int
    let jsonrpc: String
    let method: String
    let params: [String]
}
