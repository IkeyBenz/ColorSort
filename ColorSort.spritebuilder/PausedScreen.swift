//
//  PausedScreen.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PausedScreen: CCNode {
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    
}