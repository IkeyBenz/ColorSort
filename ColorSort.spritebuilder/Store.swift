//
//  Store.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class Store: CCScene, InAppPurchasesDelegate, sharingDelegate {
    
    weak var bannersClickedLabel: CCLabelTTF!
    weak var buySwipesButton: CCButton!
    weak var amountOfSwipesLabel: CCLabelTTF!
    
    func didLoadFromCCB() {
        updateAdsClickedLabel()
        updateLabel()
        InAppPurchases.sharedInstance.IAPdelegate = self
        SharingHandler.sharedInstance.delegate = self
        println("Store Loaded")
        
    }
    
    override func update(delta: CCTime) {
        updateAdsClickedLabel()
    }
    func tryAgain() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
    func writeAReview() {
        if let url = NSURL(string: "https://appsto.re/us/PVxC9.i") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    func watchAnAd() {
        println("watch an ad was pressed")
        
        
    }
    func shareWithFriends() {
        SharingHandler.sharedInstance.postToTwitter(stringToPost: "Can't stop playing Color Sorter! #mustBeatMyHighScore", postWithScreenshot: true)
    }
    func purchaseSwipes() {
        InAppPurchases.sharedInstance.attemptPurchase("slowMotionSwipes")
    }
    
    
    func initializingIAP(IAPisInitializing: Bool) {
        if IAPisInitializing {
            buySwipesButton.title = "Initializing..."
        }
        
    }
    func IAPFinished(IAPFinishedInitializing: Bool, swipesWerePurchased: Bool) {
        if IAPFinishedInitializing {
            buySwipesButton.title = "Buy Swipes"
        }
        if swipesWerePurchased {
            updateLabel()
        }
    }
    func userPressedShareWithFriends(userDidShare: Bool) {
        if userDidShare {
            updateLabel()
        }
    }
    func updateLabel() {
        var increaseScale = CCActionCallBlock(block: {self.amountOfSwipesLabel.scale = 1.2})
        var updateLabel = CCActionCallBlock(block: {self.amountOfSwipesLabel.string = "Swipes Left: \(GameStateSingleton.sharedInstance.swipesLeft)"})
        var decreaseScale = CCActionCallBlock(block: {self.amountOfSwipesLabel.scale = 1})
        var delay = CCActionDelay(duration: 0.5)
        runAction(CCActionSequence(array: [increaseScale, delay, updateLabel, delay, decreaseScale]))
    }
    
    func updateAdsClickedLabel() {
        bannersClickedLabel.string = "(\(GameStateSingleton.sharedInstance.bannersClicked)/5)"
    }
    
    
}