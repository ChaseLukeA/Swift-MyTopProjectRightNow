//
//  EndGameViewController.swift
//  IcarusGame
//
//  Created by Luke A Chase on 9/26/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import UIKit
import SpriteKit


class EndGameViewController: UIViewController {
    
    var finalGameTime: CFTimeInterval!
    let highScoreManager = HighScoreController()
    let global = Global()
    
    @IBOutlet weak var timePlayedLabel: UILabel!
    
//----------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "EndGameView"
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        timePlayedLabel.text = "You lasted \(global.timeString(finalGameTime))"
        
        
        if highScoreManager.highScores.count < 10 {
            
            saveHighScore()
            
        }
        else if isTopTen(score: finalGameTime) {
            
            saveHighScore()
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        
        coder.encodeObject(finalGameTime, forKey: "savedGameTime")
        coder.encodeInt32(global.difficultyLevel, forKey: "savedDifficultyLevel")
        
        super.encodeRestorableStateWithCoder(coder)
        
    }
    
    
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        
        finalGameTime = coder.decodeObjectForKey("savedGameTime") as! CFTimeInterval
        global.difficultyLevel = coder.decodeInt32ForKey("savedDifficultyLevel")
        
        super.decodeRestorableStateWithCoder(coder)
        
    }
    
//  HIGH SCORE FUNCTIONS  ----------------------------------------------------//
    
    func isTopTen(score score: CFTimeInterval) -> Bool {
        
        for highScore in highScoreManager.highScores {
            
            if score > highScore.gameTime {
                
                return true
                
            }
            
        }
        
        return false
        
    }
    
    
    
    func saveHighScore() {
        
        //TO-DO: sort high scores by score and remove the lowest one when adding new high score
        var usernameTextField: UITextField!
        
        
        let newHighScoreController = UIAlertController(title: "You made the\ntop ten list!", message: "Enter your name:", preferredStyle: .Alert)
        
        newHighScoreController.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            textField.placeholder = ""
            usernameTextField = textField
        }
        
        let okAction = UIAlertAction(title: "Add me!", style: .Default, handler: {
            (action) -> Void in
            
            self.highScoreManager.highScores.append(
                HighScore(
                    gameTime: self.finalGameTime,
                    difficultyMode: self.global.difficultyLevel,
                    username: usernameTextField.text ?? "NULL"
                )
            )
            
            
            self.highScoreManager.save()
            
        })
        
        
        newHighScoreController.addAction(okAction)
        
        self.presentViewController(newHighScoreController, animated: true, completion: nil)
        
    }
    
}
