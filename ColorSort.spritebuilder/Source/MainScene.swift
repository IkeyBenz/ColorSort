import Foundation

class MainScene: CCNode {
    func play() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
}
