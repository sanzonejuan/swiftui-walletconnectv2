//
//  WalletConnectManager.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 27/02/2023.
//

import Foundation
import Combine
import Web3Wallet
import WalletConnectSign
import WalletConnectPairing
import WalletConnectNetworking

final class WalletConnectManager: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var currentSessions = [Session]()
    
    // MARK: Private Properties
    
    private let coordinator: WalletConnectCoordinator
    private let sessionProposalService: SessionProposalService
    private var publishers = [AnyCancellable]()
    private let deeplinkWalletConnectScheme: String = "wc:"
    
    // MARK: Init
    
    init(
        coordinator: WalletConnectCoordinator = WalletConnectCoordinator(),
        sessionProposalService: SessionProposalService = SessionProposalService()
    ) {
        self.coordinator = coordinator
        self.sessionProposalService = sessionProposalService
        
        let metadata = WalletConnectConfig.metadata
        Networking.configure(projectId: WalletConnectConfig.projectID, socketFactory: DefaultSocketFactory())
        Pair.configure(metadata: metadata)
        Web3Wallet.configure(metadata: metadata, signerFactory: DefaultSignerFactory())
        
        currentSessions = Web3Wallet.instance.getSessions()
        bindPublishers()
    }
    
    // MARK: Public Methods
    
    func handleDeeplinkURL(_ url: URL) {
        let deeplinkURL = url.absoluteString
        if deeplinkURL.contains(deeplinkWalletConnectScheme) {
            Task {
                try? await self.pair(stringURI: deeplinkURL)
            }
        }
    }
    
    func connectUserAction() {
        coordinator.presentEnterURIAlert { uri in
            Task {
                try? await self.pair(stringURI: uri)
            }
        }
    }
    
    func logoutSessions() async throws {
        for session in currentSessions {
            try await Web3Wallet.instance.disconnect(topic: session.topic)
        }
    }
}

// MARK: - Private Methods

private extension WalletConnectManager {
    
    func bindPublishers() {
        /// Session - Called after approve()
        Web3Wallet.instance.sessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (sessions: [Session]) in
                self.currentSessions = sessions
            }.store(in: &publishers)
        
        /// Session proposal - Called after pair()
        Web3Wallet.instance.sessionProposalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessionProposal in
                print(sessionProposal)
                /// Show dialog to confirm/reject
                self?.coordinator.presentProposalConnectionAlert(confirmHandler: { isConfirmed in
                    self?.handleProposalResponse(isConfirmed: isConfirmed, proposal: sessionProposal)
                })
            }.store(in: &publishers)
        
        /// Session request - Called from DApp
        Web3Wallet.instance.sessionRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { request in
                // TODO Juan: Handle request methods. (depends on features)
                print("Received request: \(request.method)")
            }.store(in: &publishers)
    }
    
    func pair(stringURI: String) async throws {
        try await Web3Wallet.instance.pair(uri: WalletConnectURI(string: stringURI)!)
    }
    
    func approve(proposal: Session.Proposal) async throws {
        try await sessionProposalService.approve(proposal: proposal)
    }
    
    func reject(proposal: Session.Proposal) async throws {
        try await sessionProposalService.reject(proposal: proposal)
    }
    
    func handleProposalResponse(isConfirmed: Bool, proposal: Session.Proposal) {
        if isConfirmed {
            Task {
                try? await approve(proposal: proposal)
            }
        } else {
            Task {
                try? await reject(proposal: proposal)
            }
        }
    }
}
