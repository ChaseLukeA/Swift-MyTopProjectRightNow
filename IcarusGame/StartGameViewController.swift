//
//  StartGameViewController.swift
//  IcarusGame
//
//  Created by Luke A Chase on 9/16/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import UIKit


class StartGameViewController: UIViewController {

    let global = Global()
    
    @IBOutlet weak var easyModeButton: UIButton!
    @IBOutlet weak var hardModeButton: UIButton!
    
//----------------------------------------------------------------------------//
    
    @IBAction func easyModeButton(sender: UIButton) {
        
        if global.difficultyLevel != 0 {
            global.difficultyLevel = 0
            easyModeButton.selected = true
            hardModeButton.selected = false
        }
        
    }
    
    
    
    @IBAction func hardModeButton(sender: UIButton) {
        
        if global.difficultyLevel != 1 {
            global.difficultyLevel = 1
            hardModeButton.selected = true
            easyModeButton.selected = false
        }
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.restorationIdentifier = "StartGameView"
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        switch global.difficultyLevel {
        case 1:
            hardModeButton.selected = true
        default:  // 0 "easy" is default
            easyModeButton.selected = true
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
        
        coder.encodeInt32(global.difficultyLevel, forKey: "savedDifficultyLevel")

        super.encodeRestorableStateWithCoder(coder)
        
    }
    
    
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        
        global.difficultyLevel = coder.decodeInt32ForKey("savedDifficultyLevel")

        super.decodeRestorableStateWithCoder(coder)
        
    }
    
}

