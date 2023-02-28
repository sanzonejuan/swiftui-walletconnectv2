import Foundation
import Starscream
import WalletConnectRelay

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    
    func create(with url: URL) -> WebSocketConnecting {
        // TODO: Juan - Starscream have v4.0. But we are using 3.1.2 (Same as Wallet connect main example)
        return WebSocket(url: url)
    }
}
