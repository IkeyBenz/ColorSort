//
//  Gameplay1.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit

class Gameplay: CCScene {
    
    weak var yellowColumn: CCNodeColor!
    weak var greenColumn: CCNodeColor!
    weak var purpleColumn: CCNodeColor!
    weak var blueColumn: CCNodeColor!
    weak var pinkColumn: CCNodeColor!
    
    var speed: CCTime = 4
    var tutorialFinished: Bool = false
    var difficultyDidChange: Bool = false
    var distanceBetweenColors: CCTime = 1 {
        didSet {
            unschedule("spawnColors")
            schedule("spawnColors", interval: distanceBetweenColors)
        }
    }
    var pausedbuttonPressed: Bool = false
    var new: CCLabelTTF!
    var shouldShowNewHighScore: Bool = false
    var gameoverLabelFell: Bool = false
    weak var highScoreLabel: CCLabelTTF!
    weak var pausedMenu: CCScene!
    weak var pausedButton: CCButton!
    var gameover: Bool = false
    var colorNode: CCNodeColor!
    var screenWidthPercent = CCDirector.sharedDirector().viewSize().width / 100
    var colorArray: [Colors] = []
    weak var restartButton: CCButton!
    
    var currentTouchLocation: CGPoint!
    var currentColorBeingTouched: Colors!
    
    weak var scoreLabel: CCLabelTTF!
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            updateDifficulty()
            
            if score > GameStateSingleton.sharedInstance.highscore {
                GameStateSingleton.sharedInstance.highscore = score
                GameCenterInteractor.sharedInstance.reportHighScoreToGameCenter(GameStateSingleton.sharedInstance.highscore)
                highScoreLabel.string = String("Highscore: \(GameStateSingleton.sharedInstance.highscore)")
                shouldShowNewHighScore = true
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
            xPosition = 2 * (width / 5) + widthOffset
        } else if randomNumber == 3 {
            xPosition = 3 * (width / 5) + widthOffset
        } else if randomNumber == 4 {
            xPosition = 4 * (width / 5) + widthOffset
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
                addChild(nextColor)
                nextColor.position = ccp(randomX(), CCDirector.sharedDirector().viewSize().height)
                nextColor.move(speed)
            }
        }
    }
    
    func didLoadFromCCB() {
//        iAdHandler.sharedInstance.displayBannerAd()
        userInteractionEnabled = true
        highScoreLabel.string = String("Highscore: \(GameStateSingleton.sharedInstance.highscore)")
        if !GameStateSingleton.sharedInstance.alreadyLoaded {
            animationManager.runAnimationsForSequenceNamed("Tutorial")
            GameStateSingleton.sharedInstance.alreadyLoaded = true
        } else {
            tutorialFinished = true
        }
        schedule("spawnColors", interval: CCTime(distanceBetweenColors))
        
    }
    
    override func update(delta: CCTime) {
        for color in colorArray {
            if color.position.y < screenWidthPercent * 12 {
                color.removeFromParent()
                colorArray.removeAtIndex(find(colorArray, color)!)
                checkForColor(color)
            }
        }
        
        if gameover {
            restartButton.visible = true
            pausedButton.visible = false
            for color in colorArray {
                color.removeFromParent()
            }
            if !gameoverLabelFell {
                animationManager.runAnimationsForSequenceNamed("Game Over")
                gameoverLabelFell = true
            }
            if shouldShowNewHighScore {
                new.visible = true
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
            if currentColorBeingTouched.position.y < CCDirector.sharedDirector().viewSize().height / 10 {
                gameover = true
            }
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if currentColorBeingTouched != nil {
            repositionColor(currentColorBeingTouched)
            currentColorBeingTouched = nil
        }
    }
    
    func repositionColor(color: Colors) {
        var reposition: CCActionMoveBy!
        
        
        if color.position.x < screenWidthPercent * 20 {
            color.position.x = screenWidthPercent * 10
            changeOpacity(yellowColumn)
        } else if color.position.x < (screenWidthPercent * 40) && color.position.y > (screenWidthPercent * 20) {
            changeOpacity(greenColumn)
            color.position.x = screenWidthPercent * 30
        } else if color.position.x < (screenWidthPercent * 60) && color.position.y > (screenWidthPercent * 40) {
            changeOpacity(purpleColumn)
            color.position.x = screenWidthPercent * 50
        } else if color.position.x < (screenWidthPercent * 80) && color.position.y > (screenWidthPercent * 60) {
            changeOpacity(blueColumn)
            color.position.x = screenWidthPercent * 70
        } else if color.position.x > screenWidthPercent * 80 {
            changeOpacity(pinkColumn)
            color.position.x = screenWidthPercent * 90
        }
        
    }
    // Change opacity of columns when colors are dropped in them
    func changeOpacity(colornode: CCNodeColor) {
        colornode.opacity = 0.7
        var delay = CCActionDelay(duration: CCTime(0.1))
        var callblock = CCActionCallBlock(block: {colornode.opacity = 0.3})
        runAction(CCActionSequence(array: [delay, callblock]))
    }
    
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
            speed = 4
            distanceBetweenColors = 1
        } else if score < 20 && score >= 10 {
            speed = 2.7
            distanceBetweenColors = 0.9
        } else if score < 30 && score >= 20 {
            speed = 3.4
            distanceBetweenColors = 0.8
        } else if score < 40 && score >= 30 {
            speed = 3.1
            distanceBetweenColors = 0.7
        } else if score < 50 && score >= 40 {
            speed = 2.8
            distanceBetweenColors = 0.6
        } else if score < 60 && score >= 50 {
            speed = 2.5
            distanceBetweenColors = 0.5
        } else if score < 70 && score >= 60 {
            speed = 2.2
            distanceBetweenColors = 0.4
        } else if score < 80 && score >= 70 {
            speed = 1.9
            distanceBetweenColors = 0.3
        } else if score < 90 && score >= 80 {
            speed = 1.6
            distanceBetweenColors = 0.2
        } else if score < 100 && score >= 90 {
            speed = 1.3
            distanceBetweenColors = 0.2
        } else if score < 110 && score >= 100 {
            speed = 1
            distanceBetweenColors = 0.1
        } else if score < 120 && score >= 110 {
            speed = 0.7
            distanceBetweenColors = 0.1
        } else if score < 130 && score >= 120 {
            speed = 0.4
            distanceBetweenColors = 0.05
        }
    }
    
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
    func pause() {
        if pausedButton.selected {
            paused = false
            pausedMenu.visible = false
            pausedButton.selected = false
            userInteractionEnabled = true
        } else if !pausedButton.selected {
            paused = true
            pausedMenu.visible = true
            pausedButton.selected = true
            userInteractionEnabled = false
        }
    }
    func startGame() {
        tutorialFinished = true
    }
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    func leaderboard() {
        showLeaderboard()
    }
    
    
}


extension Gameplay: GKGameCenterControllerDelegate {
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







