// Copyright © 2567 BE akaMiWP. All rights reserved.

struct JSONRPCResponse<Result>: Decodable where Result: Decodable {
    let jsonrpc: String
    let id: Int
    let result: Result
}
