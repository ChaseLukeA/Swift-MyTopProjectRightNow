//
//  HighScoreViewController.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/18/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import UIKit


class HighScoreViewController: UIViewController {
    
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    let highScoreManager = HighScoreController()
    let global = Global()
    
//----------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        highScoreManager.sortAndRemoveLastScore()
        
        var topTenHighScores = ""
        
        for (index, score) in highScoreManager.highScores.enumerate() {
            
            let padding = index < 10 ? " " : ""
            topTenHighScores += "\n[\(index + 1)]\(padding)\t\t\(global.timeString(score.gameTime)) (\(score.difficultyMode) Mode)\t\t\(score.username)\n"
            
        }
        
        highScoreLabel.text = topTenHighScores
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
}