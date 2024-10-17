// Copyright © 2567 BE akaMiWP. All rights reserved.

import Combine
import WalletCore

protocol SupportNetworksUseCase {
    func fetchNetworkModel(from chainId: String) -> AnyPublisher<NetworkModel, Error>
    func fetchSelectedChainIdPublisher() -> AnyPublisher<String, Never>
    func makeNetworkModelsPublisher(from selectedChainId: String) -> AnyPublisher<NetworkModels, Never>
    func selectNetworkPublisher(from chainId: String) -> AnyPublisher<Void, Error>
}

final class SupportNetworksImp: SupportNetworksUseCase {
    private var networkModels: NetworkModels = .init(mainnets: [], testnets: [])
    
    func fetchNetworkModel(from chainId: String) -> AnyPublisher<NetworkModel, Error> {
        let mainnets = MainnetNetwork.allCases
        let testnets = TestNetwork.allCases
        
        if let network = mainnets.first(where: { $0.chainId == chainId }) {
            let chainName = CoinTypeConfiguration.getName(type: network.coinType)
            let model: NetworkModel = .init(
                chainName: chainName,
                chainId: network.chainId,
                coinType: network.coinType,
                isSelected: true
            )
            return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else if let network = testnets.first(where: { $0.chainId == chainId }) {
            let chainName: String
            let chainId: String
            switch network {
            case .sepolia:
                chainName = ChainNameConstants.sepolia
                chainId = ChainIdConstants.sepolia
            }
            let model: NetworkModel = .init(
                chainName: chainName,
                chainId: chainId,
                coinType: network.coinType,
                isSelected: true
            )
            return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: SupportedNetworkUseCaseError.unableToFetchNetworkModel).eraseToAnyPublisher()
        }
    }
    
    func fetchSelectedChainIdPublisher() -> AnyPublisher<String, Never> {
        Just(HDWalletManager.shared.selectedNetwork.chainId).eraseToAnyPublisher()
    }
    
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
        
        networkModels = .init(mainnets: mainnets, testnets: testnets)
        return Just(networkModels).eraseToAnyPublisher()
    }
    
    func selectNetworkPublisher(from chainId: String) -> AnyPublisher<Void, Error> {
        let selectedMainnetNetwork = networkModels.mainnets.first(where: { $0.chainId == chainId })
        let selectedTestnetNetwork = networkModels.testnets.first(where: { $0.chainId == chainId })
        
        if let selectedMainnetNetwork = selectedMainnetNetwork,
           let network: MainnetNetwork = .init(from: selectedMainnetNetwork.coinType)  {
            HDWalletManager.shared.select(network: .mainnet(network))
        } else if let selectedTestnetNetwork = selectedTestnetNetwork,
                  let network: TestNetwork = .init(from: selectedTestnetNetwork.coinType)  {
            HDWalletManager.shared.select(network: .testnet(network))
        } else {
            return Fail(error: SupportedNetworkUseCaseError.unableToFindSelectedChainId).eraseToAnyPublisher()
        }
        
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

// MARK: - Private
private enum SupportedNetworkUseCaseError: Error {
    case unableToFindSelectedChainId
    case unableToFetchNetworkModel
}
