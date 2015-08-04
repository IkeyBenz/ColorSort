//
//  Gameplay.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCScene, CCPhysicsCollisionDelegate {
    
    var gamePhysicsNode: CCPhysicsNode!
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    var ikeysColor: CCColor!
    
    
    override func update(delta: CCTime) {
        var rand = arc4random_uniform(1000)
        if rand < 10 {
            spawnColors()
        }
    }
    
    func didloadFromCCB() {
        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
    }
    
    func spawnColors() {
        var color = CCBReader.load("ColorBox") as! Colors
        var xPosition: CGFloat!
        var randomNumber = arc4random_uniform(5)
        
        var widthOffset = width/10
        
        if randomNumber == 0 {
            xPosition = widthOffset
        } else if randomNumber == 1 {
            xPosition = width / 5 + widthOffset
        } else if randomNumber == 2 {
            xPosition = 2 * (width / 5) + widthOffset
        } else if randomNumber == 3 {
            xPosition = 3 * (width / 5) + widthOffset
        } else if randomNumber == 4 {
            xPosition = 4 * (width / 5) + widthOffset
        }
        
        
        color.colorNode.color = randomColorPicker()
        color.position = ccp(xPosition, height)
        gamePhysicsNode.addChild(color)
        color.move()
    }
    
    func randomColorPicker() -> CCColor {
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
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, colorChecker: CCNode!, color: CCNode!) -> Bool {
        println("Collided!")
        return true
    }
    
    
}