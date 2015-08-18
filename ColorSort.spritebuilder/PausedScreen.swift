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
    weak var soundEffectsLabel: CCLabelTTF!
    weak var backgroundMusicLabel: CCLabelTTF!
    
    override func onEnter() {
        updateEffectsLabel()
        updateBgButtonLabel()
    }
   
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    func toggleEffectsEnabled() {
        if GameStateSingleton.sharedInstance.soundeffectsEnabled == true {
            GameStateSingleton.sharedInstance.soundeffectsEnabled = false
            updateEffectsLabel()
            
        } else if GameStateSingleton.sharedInstance.soundeffectsEnabled == false {
            GameStateSingleton.sharedInstance.soundeffectsEnabled = true
            updateEffectsLabel()
        }
    }
    func toggleBackgroundMusic() {
        if GameStateSingleton.sharedInstance.backgroundMusicEnabled {
            GameStateSingleton.sharedInstance.backgroundMusicEnabled = false
        } else if !GameStateSingleton.sharedInstance.backgroundMusicEnabled {
            GameStateSingleton.sharedInstance.backgroundMusicEnabled = true
        }
        updateBgButtonLabel()
    }
    
    func updateEffectsLabel () {
        if GameStateSingleton.sharedInstance.soundeffectsEnabled == true {
            soundEffectsLabel.string = "Sound Effects: On"
        } else if GameStateSingleton.sharedInstance.soundeffectsEnabled == false {
            soundEffectsLabel.string = "Sound Effects: Off"
        }
    }
    
    func updateBgButtonLabel() {
        if GameStateSingleton.sharedInstance.backgroundMusicEnabled == true {
            backgroundMusicLabel.string = "Music: On"
        } else if GameStateSingleton.sharedInstance.backgroundMusicEnabled == false {
            backgroundMusicLabel.string = "Music: Off"
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
