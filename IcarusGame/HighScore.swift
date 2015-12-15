//
//  HighgameTime.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/18/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import Foundation


class HighScore: NSObject, NSCoding {
    
    let gameTime: CFTimeInterval
    let username: String
    let difficultyMode: String
    
//----------------------------------------------------------------------------//
    
    init(gameTime: CFTimeInterval, difficultyMode: Int32, username: String) {
        
        self.gameTime = gameTime
        self.username = username
        self.difficultyMode = difficultyMode == 0 ? "Easy" : "Hard"
        
    }
    
    
    
    required init(coder: NSCoder) {
        
        self.gameTime = coder.decodeObjectForKey("gameTime") as! CFTimeInterval
        self.username = coder.decodeObjectForKey("username") as! String
        self.difficultyMode = coder.decodeObjectForKey("difficultyMode") as! String
        
        super.init()
        
    }
    
    
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(gameTime, forKey: "gameTime")
        coder.encodeObject(username, forKey: "username")
        coder.encodeObject(difficultyMode, forKey: "difficultyMode")
        
    }
    
}
