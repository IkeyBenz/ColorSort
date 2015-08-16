import Foundation
import GameKit



class MainScene: CCNode {
    func didLoadFromCCB() {
        iAdHandler.sharedInstance.loadAds(bannerPosition: .Bottom)
        setUpGameCenter()
    }
    func play() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
}



extension MainScene: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
}
