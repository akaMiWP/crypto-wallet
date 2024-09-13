// Copyright © 2567 BE akaMiWP. All rights reserved.

struct JSONRPCResponse<Result>: Decodable where Result: Decodable {
    struct Error: Decodable {
        let code: Int
        let message: String
    }
    
    let jsonrpc: String
    let id: Int
    let result: Result?
    let error: Error?
}
