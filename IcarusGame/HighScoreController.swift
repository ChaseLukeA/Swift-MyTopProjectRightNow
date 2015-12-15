//
//  HighScoreController.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/18/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import Foundation


class HighScoreController {
    
    var highScores: Array<HighScore> = []
    
//----------------------------------------------------------------------------//
    
    init() {
        
        let pathSearch = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = pathSearch[0] as NSString
        let highScoresPlist = documentDirectory.stringByAppendingPathComponent("highScores.plist")
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(highScoresPlist) {
            
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                
                do {
                    try fileManager.copyItemAtPath(bundle, toPath: highScoresPlist)
                }
                catch {
                    print("copyItemAtPath error")
                }
                
            }
            
        }
        
        if let scoreData = NSData(contentsOfFile: highScoresPlist) {
            
            let scores: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(scoreData)
            self.highScores = scores as? [HighScore] ?? []
            
        }
        
        //Global.sharedVariables.highScores = self.highScores
        
    }
    
//  HIGH SCORE FUNCTIONS  ----------------------------------------------------//
    
    func save() {
        
        self.sortAndRemoveLastScore()
        
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.highScores)
        let pathSearch = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentDirectory = pathSearch.objectAtIndex(0) as! NSString
        let highScoresPlist = documentDirectory.stringByAppendingPathComponent("highScores.plist")
        
        saveData.writeToFile(highScoresPlist, atomically: true)
    }
    
    
    
    func sortAndRemoveLastScore() {
        
        highScores.sortInPlace { (score1, score2) -> Bool in
            return score1.gameTime > score2.gameTime
        }
        
        while highScores.count > 10 {
            
            highScores.removeLast()
            
        }
        
        
    }
    
}