//
//  HomeView.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 27/02/2023.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: Dependencies
    
    @EnvironmentObject var walletConnectManager: WalletConnectManager
    
    // MARK: View
    
    var body: some View {
        NavigationView {
            sessionsListView
                .navigationTitle("Juan Wallet")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Switch to DApp") {
                            // todo juan
                        }
                    }
                }
        }
        .safeAreaInset(edge: .bottom) {
            if isConnected {
                logoutButton
            } else {
                connectButton
            }
        }
    }
    
    // MARK: Subviews
    
    @ViewBuilder
    private var sessionsListView: some View {
        if walletConnectManager.isConnected {
            List {
                Section("Active Sessions") {
                    ForEach(walletConnectManager.currentSessions, id: \.pairingTopic) { session in
                        Text(session.pairingTopic)
                    }
                }
            }
        } else {
            emptyStateView
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 4) {
            Text("Open the following URL in your browser")
            Link("https://react-app.walletconnect.com/", destination: URL(string: "https://react-app.walletconnect.com/")!)
        }
    }
    
    private var connectButton: some View {
        Button("Connect") {
            walletConnectManager.connectUserAction()
        }
        .foregroundColor(.green)
    }
    
    private var logoutButton: some View {
        Button("Logout Sessions") {
            Task {
                try? await walletConnectManager.logoutSessions()
            }
        }
        .foregroundColor(.red)
    }
}
