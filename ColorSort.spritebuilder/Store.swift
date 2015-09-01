//
//  Store.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class Store: CCScene, InAppPurchasesDelegate, sharingDelegate, ChartboostDelegate {
    
    weak var buySwipesButton: CCButton!
    weak var amountOfSwipesLabel: CCLabelTTF!
    
    override func onEnter() {
        let kChartboostAppID = "55e2b3170d60252dd5a3b10d";
        let kChartboostAppSignature = "f9fdd445ee21890d8d8871519ad32899a1f3d527";
        Chartboost.startWithAppId(kChartboostAppID, appSignature: kChartboostAppSignature, delegate: self);
        Chartboost.cacheRewardedVideo(CBLocationItemStore)
    }
    
    func didLoadFromCCB() {
        
        updateLabel()
        InAppPurchases.sharedInstance.IAPdelegate = self
        SharingHandler.sharedInstance.delegate = self
        println("Store Loaded")
        
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
        if Chartboost.hasRewardedVideo(CBLocationItemStore) {
            Chartboost.showRewardedVideo(CBLocationItemStore)
            Chartboost.cacheRewardedVideo(CBLocationItemStore)
            GameStateSingleton.sharedInstance.swipesLeft += 1
            updateLabel()
        } else {
            let alert = UIAlertView()
            alert.title = "OH NO!!!"
            alert.message = "Looks like the ads could not load!"
            alert.addButtonWithTitle("That sucks")
            alert.show()
        }
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
    
    
    
    
}