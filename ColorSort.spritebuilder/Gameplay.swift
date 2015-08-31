//
//  Gameplay1.swift
//  ColorSorter
//
//  Created by Ikey Benzaken on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit
import AudioToolbox

class Gameplay: CCScene {
    
    // COLOR COLUMNS
    weak var yellowColumn: CCNodeColor!
    weak var greenColumn: CCNodeColor!
    weak var purpleColumn: CCNodeColor!
    weak var blueColumn: CCNodeColor!
    weak var pinkColumn: CCNodeColor!
    
    // GAMEPLAY PROPERTIES
    var colorSpeed: CCTime = 4
    var screenWidthPercent = CCDirector.sharedDirector().viewSize().width / 100
    var audio = OALSimpleAudio.sharedInstance()
    var currentTouchLocation: CGPoint!
    var colorNode: CCNodeColor!
    var currentColorBeingTouched: Colors!
    var colorArray: [Colors] = []
    var swipeUp = UISwipeGestureRecognizer()
    weak var colorSpawnNode: CCNode!
    weak var highScoreLabel: CCLabelTTF!
    weak var scoreLabel: CCLabelTTF!
    weak var gameOverScore: CCLabelTTF!
    weak var swipesLeftIndicator: CCLabelTTF!
    weak var pausedMenu: CCScene!
    weak var pausedButton: CCButton!
    weak var restartButton: CCButton!
    
    
    // BOOLEANS
    var tutorialFinished: Bool = false
    var difficultyDidChange: Bool = false
    var pausedbuttonPressed: Bool = false
    var gameoverLabelFell: Bool = false
    var gameover: Bool = false
    var playerUsedSwipe: Bool = false
    
    var distanceBetweenColors: CCTime = 1 {
        didSet {
            if !slowMoActivated {
                unschedule("spawnColors")
                schedule("spawnColors", interval: distanceBetweenColors)
            }
        }
    }
    var slowMoActivated: Bool = false {
        didSet {
            if slowMoActivated {
                unschedule("spawnColors")
                colorSpeed = 4
                distanceBetweenColors = 0.7
                schedule("spawnColors", interval: distanceBetweenColors)
                var delay = CCActionDelay(duration: 6)
                var unscheduleSpawnColors = CCActionCallBlock(block: {self.unschedule("spawnColors")})
                var setSlowMoToFalse = CCActionCallBlock(block: {self.slowMoActivated = false})
                runAction(CCActionSequence(array: [delay, unscheduleSpawnColors, setSlowMoToFalse]))
                for color in colorArray {
                    color.stopAllActions()
                    color.move(4, screenHeight: -CCDirector.sharedDirector().viewSize().height)
                }
            } else if !slowMoActivated {
                updateDifficulty()
            }
        }
    }
    
    var swipesLeft = GameStateSingleton.sharedInstance.swipesLeft {
        didSet {
            animationManager.runAnimationsForSequenceNamed("Slow Mo Label")
            
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            gameOverScore.string = "Score: \(score)"
            if !slowMoActivated {
                updateDifficulty()
            }
            if score > GameStateSingleton.sharedInstance.highscore {
                GameStateSingleton.sharedInstance.highscore = score
                GameCenterInteractor.sharedInstance.reportHighScoreToGameCenter(GameStateSingleton.sharedInstance.highscore)
                
                // Here I want it to scan the leaderboard and see everyones ranking.
                // I want it to know who the player was originally above.
                // Then I want it to send a push notification to the players that this player the beat.
                
                highScoreLabel.string = String("Highscore: \(GameStateSingleton.sharedInstance.highscore)")
            }
        }
    }
    
    
    
    // Generates a random color
    func randomColor() -> CCColor {
        var ikeysColor: CCColor!
        var rand = arc4random_uniform(5)
        if rand == 0 {
            ikeysColor = CCColor(ccColor3b: ccColor3B(r: 255, g: 214, b: 75))
        } else if rand == 1 {
            ikeysColor = CCColor(ccColor3b: ccColor3B(r: 96, g: 211, b: 148))
        } else if rand == 2 {
            ikeysColor = CCColor(ccColor3b: ccColor3B(r: 164, g: 101, b: 173))
        } else if rand == 3 {
            ikeysColor = CCColor(ccColor3b: ccColor3B(r: 9, g: 77, b: 146))
        } else if rand == 4 {
            ikeysColor = CCColor(ccColor3b: ccColor3B(r: 239, g: 130, b: 117))
        }
        return ikeysColor
    }
    
    // Generate random x position for the colors
    func randomX() -> CGFloat {
        var xPosition: CGFloat!
        var randomNumber = arc4random_uniform(5)
        var width = CCDirector.sharedDirector().viewSize().width
        var widthOffset = width / 10
        if randomNumber == 0 {
            xPosition = widthOffset
        } else if randomNumber == 1 {
            xPosition = (width / 5) + widthOffset
        } else if randomNumber == 2 {
            xPosition = (2 * (width / 5)) + widthOffset
        } else if randomNumber == 3 {
            xPosition = (3 * (width / 5)) + widthOffset
        } else if randomNumber == 4 {
            xPosition = (4 * (width / 5)) + widthOffset
        }
        
        return xPosition
    }
    // creates new colors
    func spawnColors() {
        if tutorialFinished {
            if !gameover {
                var nextColor = CCBReader.load("ColorBox") as! Colors
                nextColor.colorNode.color = randomColor()
                colorArray.append(nextColor)
                colorSpawnNode.addChild(nextColor)
                nextColor.position = ccp(randomX(), CCDirector.sharedDirector().viewSize().height)
                nextColor.move(colorSpeed, screenHeight: -CCDirector.sharedDirector().viewSize().height)
            }
        }
    }
    
    
    func didLoadFromCCB() {
        iAdHandler.sharedInstance.loadAds(bannerPosition: .Bottom)
        iAdHandler.sharedInstance.displayBannerAd()
        userInteractionEnabled = true
        highScoreLabel.string = String("Highscore: \(GameStateSingleton.sharedInstance.highscore)")
        swipesLeftIndicator.string = "Swipes Left: \(swipesLeft)"
        if !GameStateSingleton.sharedInstance.alreadyLoaded {
            animationManager.runAnimationsForSequenceNamed("Tutorial")
            GameStateSingleton.sharedInstance.soundeffectsEnabled = true
            GameStateSingleton.sharedInstance.backgroundMusicEnabled = true
            GameStateSingleton.sharedInstance.alreadyLoaded = true
            GameStateSingleton.sharedInstance.swipesLeft = 4
        } else {
            tutorialFinished = true
        }
        schedule("spawnColors", interval: CCTime(distanceBetweenColors))
        
        if GameStateSingleton.sharedInstance.backgroundMusicEnabled {
            audio.playBg("A Journey Awaits.mp3", loop: true)
        }
        swipesLeftIndicator.string = "Swipes Left: \(GameStateSingleton.sharedInstance.swipesLeft)"
        setupSwipeGesture()
    }
    
    override func update(delta: CCTime) {
        for color in colorArray {
            if color.position.y < (CCDirector.sharedDirector().viewSize().height / 100) * 12 {
                checkForColor(color)
                color.removeFromParent()
                colorArray.removeAtIndex(find(colorArray, color)!)
            }
        }
        
        if gameover {
            restartButton.visible = true
            pausedButton.visible = false
            scoreLabel.visible = false
            for color in colorArray {
                color.removeFromParent()
            }
            if !gameoverLabelFell {
                animationManager.runAnimationsForSequenceNamed("Game Over")
                var takePicture = CCActionCallBlock(block: {GameStateSingleton.sharedInstance.screenShot = self.takeScreenshot()})
                var delay = CCActionDelay(duration: 1)
                runAction(CCActionSequence(array: [delay, takePicture]))
                gameoverLabelFell = true
            }
            
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        currentTouchLocation = touch.locationInWorld()
        for color in colorArray {
            if color.boundingBox().contains(currentTouchLocation) {
                currentColorBeingTouched = color
            }
        }
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if currentColorBeingTouched != nil {
            currentColorBeingTouched.position.x = touch.locationInWorld().x
            if currentColorBeingTouched.position.y <= (CCDirector.sharedDirector().viewSize().height / 100) * 12 {
                gameover = true
            }
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if currentColorBeingTouched != nil {
            repositionColor(currentColorBeingTouched)
            if effectsAreEnabled() {
                audio.playEffect("popSoundEffect.mp3")
            }
            currentColorBeingTouched = nil
        }
    }
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if currentColorBeingTouched != nil {
            repositionColor(currentColorBeingTouched)
            if effectsAreEnabled() {
                audio.playEffect("popSoundEffect.mp3")
            }
            currentColorBeingTouched = nil
        }
    }
    // Move loose colors into set columns and blink the opacity of those columns for a second
    func repositionColor(color: Colors) {
        if color.position.x <= screenWidthPercent * 20 {
            color.position.x = screenWidthPercent * 10
            changeOpacity(yellowColumn)
        } else if color.position.x <= (screenWidthPercent * 40) && color.position.y > (screenWidthPercent * 20) {
            changeOpacity(greenColumn)
            color.position.x = screenWidthPercent * 30
        } else if color.position.x < (screenWidthPercent * 60) && color.position.y > (screenWidthPercent * 40) {
            changeOpacity(purpleColumn)
            color.position.x = screenWidthPercent * 50
        } else if color.position.x < (screenWidthPercent * 80) && color.position.y >= (screenWidthPercent * 60) {
            changeOpacity(blueColumn)
            color.position.x = screenWidthPercent * 70
        } else if color.position.x >= screenWidthPercent * 80 {
            changeOpacity(pinkColumn)
            color.position.x = screenWidthPercent * 90
        } else {
            // Sometimes when colors are near the blue column the reposition doesn't work so here's the (bad) solution.
            changeOpacity(blueColumn)
            color.position.x = screenWidthPercent * 70
        }
        
    }
    // Change opacity of columns when colors are dropped in them
    func changeOpacity(colornode: CCNodeColor) {
        colornode.opacity = 0.8
        var delay = CCActionDelay(duration: CCTime(0.15))
        var callblock = CCActionCallBlock(block: {colornode.opacity = 0.5})
        runAction(CCActionSequence(array: [delay, callblock]))
    }
    // Checks to see if the colors match the column they're in, if not, gameover; if so, add a point to score.
    func checkForColor(currentColor: Colors) {
        if currentColor.position.x == screenWidthPercent * 10 {
            if currentColor.colorNode.color != CCColor(ccColor3b: ccColor3B(r: 255, g: 214, b: 75)) {
                gameover = true
            } else {
                score++
            }
        }
        if currentColor.position.x == screenWidthPercent * 30 {
            if currentColor.colorNode.color != CCColor(ccColor3b: ccColor3B(r: 96, g: 211, b: 148)) {
                gameover = true
            } else {
                score++
            }
        }
        if currentColor.position.x == screenWidthPercent * 50 {
            if currentColor.colorNode.color != CCColor(ccColor3b: ccColor3B(r: 164, g: 101, b: 173)) {
                gameover = true
            } else {
                score++
            }
        }
        if currentColor.position.x == screenWidthPercent * 70 {
            if currentColor.colorNode.color != CCColor(ccColor3b: ccColor3B(r: 9, g: 77, b: 146)) {
                gameover = true
            } else {
                score++
            }
        }
        if currentColor.position.x == screenWidthPercent * 90 {
            if currentColor.colorNode.color != CCColor(ccColor3b: ccColor3B(r: 239, g: 130, b: 117)) {
                gameover = true
            } else {
                score++
            }
        }
    }
    
    // Update difficulty
    func updateDifficulty() {
        if score < 10 {
            colorSpeed = 4
            distanceBetweenColors = 1
        } else if score < 20 && score >= 10 {
            colorSpeed = 3.7
            distanceBetweenColors = 0.9
        } else if score < 30 && score >= 20 {
            colorSpeed = 3.4
            distanceBetweenColors = 0.8
        } else if score < 40 && score >= 30 {
            colorSpeed = 3.1
            distanceBetweenColors = 0.7
        } else if score < 50 && score >= 40 {
            colorSpeed = 2.8
            distanceBetweenColors = 0.6
        } else if score < 60 && score >= 50 {
            colorSpeed = 2.5
            distanceBetweenColors = 0.5
        } else if score < 80 && score >= 60 {
            colorSpeed = 2.2
            distanceBetweenColors = 0.4
        } else if score < 100 && score >= 80 {
            colorSpeed = 2
            distanceBetweenColors = 0.4
        } else if score < 120 && score >= 100 {
            colorSpeed = 1.9
            distanceBetweenColors = 0.37
        } else if score < 140 && score >= 120 {
            colorSpeed = 1.75
            distanceBetweenColors = 0.34
        } else if score < 160 && score >= 140 {
            colorSpeed = 1.6
            distanceBetweenColors = 0.31
        } else if score < 180 && score >= 160 {
            colorSpeed = 1.5
            distanceBetweenColors = 0.285
        } else if score >= 180 {
            colorSpeed = 1.45
            distanceBetweenColors = 0.25
        }
    }
    // Checks if sound effects are enabled
    func effectsAreEnabled() -> Bool {
        if GameStateSingleton.sharedInstance.soundeffectsEnabled {
            return true
        }
        return false
    }
    // Sets up our swipe up gesture
    
    func setupSwipeGesture() {
        swipeUp = UISwipeGestureRecognizer(target: self, action: "activateSlowMo")
        swipeUp.direction = .Up
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp)
    }
    func activateSlowMo() {
        if !gameover {
            if !slowMoActivated {
                if !playerUsedSwipe {
                    if swipesLeft > 0 {
                        slowMoActivated = true
                        animationManager.runAnimationsForSequenceNamed("Slow Mo Label")
                        playerUsedSwipe = true
                    } else {
                        animationManager.runAnimationsForSequenceNamed("Slow Mo Label")
                        swipesLeftIndicator.color = CCColor(ccColor3b: ccColor3B(r: 225, g: 0, b: 0))
                    }
                } else if playerUsedSwipe {
                    // Show a label saying ~you already used your swipe for the game
                }
            }
        }
    }
    
    func takeScreenshot() -> UIImage {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        
        let width = Int32(CCDirector.sharedDirector().viewSize().width)
        let height = Int32(CCDirector.sharedDirector().viewSize().height)
        let renderTexture: CCRenderTexture = CCRenderTexture(width: width, height: height)
        
        renderTexture.begin()
        CCDirector.sharedDirector().runningScene.visit()
        renderTexture.end()
        
        return renderTexture.getUIImage()
    }
    
    
    // BUTTONS
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
    func pause() {
        if pausedButton.selected {
            paused = false
            pausedMenu.visible = false
            pausedButton.selected = false
            userInteractionEnabled = true
            if GameStateSingleton.sharedInstance.backgroundMusicEnabled {
                audio.paused = false
            }
        } else if !pausedButton.selected {
            paused = true
            pausedMenu.visible = true
            pausedButton.selected = true
            userInteractionEnabled = false
            audio.paused = true
        }
    }
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
        audio.stopBg()
    }
    func showStore() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Store"))
        CCDirector.sharedDirector().view.removeGestureRecognizer(swipeUp)
    }
    
    // CALLBACKS
    func startGame() {
        tutorialFinished = true
    }
    func decreaseAmountOfSwipes() {
        if GameStateSingleton.sharedInstance.swipesLeft > 0 {
            GameStateSingleton.sharedInstance.swipesLeft -= 1
            swipesLeftIndicator.string = "Swipes Left: \(GameStateSingleton.sharedInstance.swipesLeft)"
        }
    }
    
}

// GAMECENTER
extension Gameplay: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
        audio.stopBg()
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
}







