import MultipeerConnectivity
import SpriteKit
import SwiftP2PConnector

class ControlVC: UIViewController, ReceiveDelegate {

	var gameID: MCPeerID? = nil
	lazy var scene = SKScene(size: view.bounds.size)
	lazy var commandDictionary: [String: Command] = [CommandKeys.changeColorToGreen.rawValue:
														ChangeColorCommand(scene: scene, color: .systemGreen),
													 CommandKeys.changeColorToPurple.rawValue:
														ChangeColorCommand(scene: scene, color: .systemPurple)]
	
	override func viewDidLoad() {
		super.viewDidLoad()

		P2PConnector.peerBrowserVCDelegate = self
		P2PConnector.receiveDelegate = self
		P2PConnector.connectionDelegate = self

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
		if gameID == nil {
			lookForSession()
		}
	}

	func didReceiveData(_ data: Data, from peerID: MCPeerID) {
		guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {return}

		DispatchQueue.main.async { [weak self] in
			self?.scene.backgroundColor = color
		}
	}

	func sendData(_ data: Data) {
		guard let gameID else {return}
		P2PConnector.sendData(data, to: [gameID])
	}
}
