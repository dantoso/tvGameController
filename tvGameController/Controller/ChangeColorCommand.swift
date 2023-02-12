import Foundation
import SpriteKit
import SwiftP2PConnector

struct ChangeColorCommand: Command {
	let scene: SKScene
	let color: UIColor

	func action() {
		DispatchQueue.main.async {
			scene.backgroundColor = color
		}
	}
}
