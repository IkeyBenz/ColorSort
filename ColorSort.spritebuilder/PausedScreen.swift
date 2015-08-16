//
//  PausedScreen.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit

class PausedScreen: CCNode {
    weak var soundLabel: CCLabelTTF!
    
    override func onEnter() {
        updateLabel()
    }
   
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    func leaderboard() {
        showLeaderboard()
    }
    func toggleEffectsEnabled() {
        if GameStateSingleton.sharedInstance.soundeffectsEnabled == true {
            GameStateSingleton.sharedInstance.soundeffectsEnabled = false
            updateLabel()
            
        } else if GameStateSingleton.sharedInstance.soundeffectsEnabled == false {
            GameStateSingleton.sharedInstance.soundeffectsEnabled = true
            updateLabel()
        }
    }
    
    func updateLabel () {
        if GameStateSingleton.sharedInstance.soundeffectsEnabled == true {
            soundLabel.string = "Sound: On"
        } else if GameStateSingleton.sharedInstance.soundeffectsEnabled == false {
            soundLabel.string = "Sound: Off"
        }
    }
    
}

extension PausedScreen: GKGameCenterControllerDelegate {
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
