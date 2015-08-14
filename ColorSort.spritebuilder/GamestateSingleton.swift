//
//  Singleton.swift
//  Seige
//
//  Created by Luke Solomon on 7/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameStateSingleton: NSObject {
    
    var alreadyLoaded: Bool = NSUserDefaults.standardUserDefaults().boolForKey("AlreadyLoaded") {
        didSet {
            NSUserDefaults.standardUserDefaults().setBool(alreadyLoaded, forKey: "AlreadyLoaded")
        }
    }
    
    var highscore: Int = NSUserDefaults.standardUserDefaults().integerForKey("Highscore") {
        didSet {
            NSUserDefaults.standardUserDefaults().setInteger(highscore, forKey: "Highscore")
        }
    }
    
    
    class var sharedInstance : GameStateSingleton {
        struct Static {
            static let instance : GameStateSingleton = GameStateSingleton()
        }
        return Static.instance
    }
    
}