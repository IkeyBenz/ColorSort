//
//  Colors.swift
//  ColorSort
//
//  Created by Ikey Benzaken on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Colors: CCNode {
    var colorNode: CCNodeColor!
    
    func move() {
        var move: CCActionMoveTo
        var callblock = CCActionCallBlock(block: {self.removeFromParent()})
        move = CCActionMoveTo(duration: 1, position: ccp(position.x, 20))
        runAction(CCActionSequence(array: [move, callblock]))
        
    }
}