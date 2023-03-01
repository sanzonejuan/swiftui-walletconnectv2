//
//  JuanWalletApp.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 27/02/2023.
//

import SwiftUI

@main
struct JuanWalletApp: App {
    
    // MARK: Private Properties
    
    private let walletConnectManager = WalletConnectManager()
    
    // MARK: App
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(walletConnectManager)
                .onOpenURL { url in
                    walletConnectManager.handleDeeplinkURL(url)
                }
        }
    }
}
