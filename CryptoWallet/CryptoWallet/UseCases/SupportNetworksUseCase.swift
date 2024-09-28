// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol SupportNetworksUseCase {
    func makeNetworkModelsPublisher() -> AnyPublisher<NetworkModels, Never>
}

final class SupportedNetworkImp: SupportNetworksUseCase {
    func makeNetworkModelsPublisher() -> AnyPublisher<NetworkModels, Never> {
        let mainnets: [NetworkModel] = MainnetNetwork.allCases.compactMap { network -> NetworkModel in
            let coinType = network.coinType
            let chainName = CoinTypeConfiguration.getName(type: coinType)
            return .init(chainName: chainName, chainId: coinType.chainId, coinType: coinType)
        }
        
        let testnets: [NetworkModel] = TestNetwork.allCases.compactMap { network -> NetworkModel in
            let chainName: String
            let chainId: String
            switch network {
            case .sepolia:
                chainName = "Sepolia"
                chainId = "11155111"
            }
            return .init(chainName: chainName, chainId: chainId, coinType: network.coinType)
            
        }
        
        let models: NetworkModels = .init(mainnets: mainnets, testnets: testnets)
        return Just(models).eraseToAnyPublisher()
    }
}

import WalletCore
struct NetworkModel {
    let chainName: String
    let chainId: String
    let coinType: CoinType
}

struct NetworkModels {
    let mainnets: [NetworkModel]
    let testnets: [NetworkModel]
}
