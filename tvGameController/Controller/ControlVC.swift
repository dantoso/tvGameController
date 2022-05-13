import UIKit
import MultipeerConnectivity
import SpriteKit

class ControlVC: UIViewController {

	var id: MCPeerID!
	var mcSession: MCSession!
	lazy var advertiser = MCAdvertiserAssistant(serviceType: "mdv-hm", discoveryInfo: nil, session: mcSession)
	lazy var scene = SKScene(size: view.bounds.size)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		id = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: id, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
		
		view = SKView(frame: view.bounds)
		
		scene.scaleMode = .aspectFill
		scene.addChild(Joystick(rect: scene.frame, vc: self))
		
		guard let view = view as? SKView else {return}
		
		view.ignoresSiblingOrder = true
		
		view.showsFPS = true
		view.showsNodeCount = true
		view.showsPhysics = true
		view.preferredFramesPerSecond = 60
		
		view.presentScene(scene)
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if mcSession.connectedPeers.count < 1 {
			advertiser.start()
			joinSession()
		}
	}


}

