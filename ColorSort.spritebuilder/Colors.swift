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
    
    func move(speed: CCTime) {
        var move: CCActionMoveTo
        move = CCActionMoveTo(duration: speed, position: ccp(position.x, 20))
        runAction(CCActionSequence(array: [move]))
    }
}