// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine

protocol SupportNetworksUseCase {
    func fetchSelectedChainIdPublisher() -> AnyPublisher<String, Never>
    func makeNetworkModelsPublisher(from selectedChainId: String) -> AnyPublisher<NetworkModels, Never>
}

final class SupportedNetworkImp: SupportNetworksUseCase {
    func makeNetworkModelsPublisher(from selectedChainId: String) -> AnyPublisher<NetworkModels, Never> {
        let mainnets: [NetworkModel] = MainnetNetwork.allCases.compactMap { network -> NetworkModel in
            let coinType = network.coinType
            let chainName = CoinTypeConfiguration.getName(type: coinType)
            return .init(
                chainName: chainName,
                chainId: coinType.chainId,
                coinType: coinType,
                isSelected: selectedChainId == coinType.chainId
            )
        }
        
        let testnets: [NetworkModel] = TestNetwork.allCases.compactMap { network -> NetworkModel in
            let chainName: String
            let chainId: String
            switch network {
            case .sepolia:
                chainName = ChainNameConstants.sepolia
                chainId = ChainIdConstants.sepolia
            }
            return .init(
                chainName: chainName,
                chainId: chainId,
                coinType: network.coinType,
                isSelected: selectedChainId == chainId
            )
            
        }
        
        let models: NetworkModels = .init(mainnets: mainnets, testnets: testnets)
        return Just(models).eraseToAnyPublisher()
    }
    
    func fetchSelectedChainIdPublisher() -> AnyPublisher<String, Never> {
        Just(HDWalletManager.shared.selectedNetwork.coinType.chainId).eraseToAnyPublisher()
    }
}

struct ChainNameConstants {
    static let sepolia = "Sepolia"
}

struct ChainIdConstants {
    static let ethereum = "1"
    static let optimism = "10"
    static let zkSync = "324"
    static let arbitrumOne = "42161"
    static let sepolia = "11155111"
}

import WalletCore
struct NetworkModel {
    let chainName: String
    let chainId: String
    let coinType: CoinType
    let isSelected: Bool
}

struct NetworkModels {
    let mainnets: [NetworkModel]
    let testnets: [NetworkModel]
}