//
//  Store.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class Store: CCScene, InAppPurchasesDelegate, sharingDelegate {
    weak var buySwipesButton: CCButton!
    weak var amountOfSwipesLabel: CCLabelTTF!
    
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
        println("Write a review was pressed")
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
        amountOfSwipesLabel.string = "Swipes Left: \(GameStateSingleton.sharedInstance.swipesLeft)"
    }
    
}