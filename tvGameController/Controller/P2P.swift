import SpriteKit
import MultipeerConnectivity
import SwiftP2PConnector

extension ControlVC: ConnectionDelegate {
	func didDisconnect(to peerID: MCPeerID) {
		gameID = nil
		print("\(peerID.displayName): Disconnected")
	}

	func isConnecting(to peerID: MCPeerID) {
		print("\(peerID.displayName): Connecting...")
	}

	func didConnect(to peerID: MCPeerID) {
		gameID = peerID
		shouldPing = true
		print("\(peerID.displayName): Connected!")
	}
}


extension ControlVC: MCBrowserViewControllerDelegate {
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}

	func lookForSession() {
		let browserVC = P2PConnector.createBrowserVC()
		present(browserVC, animated: true)
	}
}
