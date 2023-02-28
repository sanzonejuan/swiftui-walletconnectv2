//
//  WalletConnectCoordinator.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 28/02/2023.
//

import SwiftUI

final class WalletConnectCoordinator: ObservableObject {
    
    func presentProposalConnectionAlert(confirmHandler: @escaping (Bool) -> Void) {
        guard let presenter = UIViewController.topMostViewController() else { return }
        
        let alert = UIAlertController(
            title: "Confirm connection",
            message: "Do you want to connect?",
            preferredStyle: .actionSheet
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            confirmHandler(false)
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            confirmHandler(true)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.preferredAction = confirmAction
        
        presenter.present(alert, animated: UIView.areAnimationsEnabled)
    }
    
    func presentEnterURIAlert(enteredURICallback: @escaping (String) -> Void) {
        guard let presenter = UIViewController.topMostViewController() else { return }
        let alert = UIAlertController.createWCAddURIAlert { uri in
            enteredURICallback(uri)
        }
        presenter.present(alert, animated: UIView.areAnimationsEnabled)
    }
}
