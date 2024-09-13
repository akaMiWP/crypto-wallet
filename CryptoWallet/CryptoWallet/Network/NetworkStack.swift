// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import Foundation

//TODO: Refactor this to make it testable
final class NetworkStack {
    
    enum Method: String {
        case tokenBalances = "alchemy_getTokenBalances"
        case tokenMetadata = "alchemy_getTokenMetadata"
    }
    
    private let session: NetworkSession
      
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchServiceProviderAPI<T>(method: Method, params: [String]) -> AnyPublisher<T, any Error> where T: Decodable {
        guard let url: URL = .init(string: "https://eth-mainnet.g.alchemy.com/v2/docs-demo") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var urlRequest: URLRequest = .init(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let request: JSONRPCRequest = .init(id: 1, jsonrpc: "2.0", method: method.rawValue, params: params)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return session.publisher(for: urlRequest)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol NetworkSession {
    func publisher(for urlRequest: URLRequest) -> AnyPublisher<Data, URLError>
}

extension URLSession: NetworkSession {
    func publisher(for urlRequest: URLRequest) -> AnyPublisher<Data, URLError> {
        DataTaskPublisher(request: urlRequest, session: self)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
