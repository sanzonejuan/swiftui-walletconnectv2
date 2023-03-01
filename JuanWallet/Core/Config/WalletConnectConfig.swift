//
//  WalletConnectConfig.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 27/02/2023.
//

import Foundation
import WalletConnectPairing

enum WalletConnectConfig {
    
    // Configure projectID on https://cloud.walletconnect.com/
    static let projectID = "replaceWithYourProjectID"
    
    static let metadata = AppMetadata(
        name: "Juan Wallet",
        description: "Juan exampke description",
        url: "js.juanwallet",
        icons: ["https://avatars.githubusercontent.com/u/3774455"]
    )
}
