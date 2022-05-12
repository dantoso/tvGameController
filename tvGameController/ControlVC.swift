import UIKit
import MultipeerConnectivity
import SpriteKit

class ControlVC: UIViewController {

	var id: MCPeerID!
	var mcSession: MCSession!
	var advertiser: MCAdvertiserAssistant!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		id = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: id, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
		
		view = SKView(frame: view.bounds)
		
		let scene = SKScene(size: view.bounds.size)
		scene.addChild(Joystick(rect: scene.frame, vc: self))
		
		guard let view = view as? SKView else {return}
		
		view.ignoresSiblingOrder = true
		
		view.showsFPS = true
		view.showsNodeCount = true
		view.showsPhysics = true
		view.preferredFramesPerSecond = 60
		
		view.presentScene(scene)
		
		joinSession()
		
	}


}

