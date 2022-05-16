import SpriteKit
import MultipeerConnectivity

extension ControlVC: MCSessionDelegate {
	
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
		case .notConnected:
			print("\(peerID.displayName): Disconnected")
			
		case .connecting:
			print("\(peerID.displayName): Connecting...")
			
			if mcSession.connectedPeers.count > 2 {
				print("\(peerID.displayName): Cancelling connection...")
				mcSession.cancelConnectPeer(peerID)
			}
			
		case .connected:
			advertiser.stop()
			print("\(peerID.displayName): Connected!")
			
		@unknown default:
			print("some weird shit just happend")
		}
	}
	
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {return}
		
		DispatchQueue.main.async { [weak self] in
			self?.scene.backgroundColor = color
		}
		
	}
	
	func lookForSession() {
		advertiser.start()
		let mcBrowser = MCBrowserViewController(serviceType: "mdv-hm", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
	}
	
	func sendData(_ data: Data) {
		guard mcSession.connectedPeers.count > 0 else {return}
		do {
			try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
			print("data from \(id.displayName) sent")
		}
		catch let error as NSError {
		   let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
		   ac.addAction(UIAlertAction(title: "OK", style: .default))
		   present(ac, animated: true)
	   }
	}
	
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
		
	}
	
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
		
	}
	
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
		
	}
	
}

extension ControlVC: MCBrowserViewControllerDelegate {
	
//	func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
//		<#code#>
//	}
//
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true, completion: nil)
	}
	
}
