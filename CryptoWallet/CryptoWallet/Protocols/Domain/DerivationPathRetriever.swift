// Copyright © 2567 BE akaMiWP. All rights reserved.

import WalletCore

protocol DerivationPathRetriever {
    func getWalletAddressUsingDerivationPath(
        wallet: HDWallet,
        coinType: CoinType,
        order: Int
    ) -> String
    
    func getPrivateKeyData(wallet: HDWallet, coinType: CoinType, order: Int) -> Data
}

extension DerivationPathRetriever {
    func getWalletAddressUsingDerivationPath(
        wallet: HDWallet,
        coinType: CoinType,
        order: Int
    ) -> String {
        let deriviationPath = buildEthAddressUsingDeriviationPath(order: order)
        let privateKey = wallet.getKey(coin: coinType, derivationPath: deriviationPath)
        let walletAddress = coinType.deriveAddress(privateKey: privateKey)
        return walletAddress
    }
    
    func getPrivateKeyData(wallet: HDWallet, coinType: CoinType, order: Int) -> Data {
        let deriviationPath = buildEthAddressUsingDeriviationPath(order: order)
        return wallet.getKey(coin: coinType, derivationPath: deriviationPath).data
    }
}

// MARK: - Private
private extension DerivationPathRetriever {
    func buildEthAddressUsingDeriviationPath(order: Int = 0) -> String {
        "m/44\'/60\'/\(order)\'/0/0"
    }
}
