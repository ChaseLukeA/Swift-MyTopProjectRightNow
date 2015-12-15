//
//  GameViewController.swift
//  IcarusGame
//
//  Created by Luke A Chase on 9/16/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var gameView: SKView!
    var gamePausedWithAnimation = false  // soft pause, allows effects nodes to still display
    let global = Global()
    
    @IBOutlet weak var gameCurrentTimeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var currentHealth: UILabel!
    
//----------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.restorationIdentifier = "GameView"
        
        
        gameView = self.view as! SKView
        gameView.ignoresSiblingOrder = false
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        
        gameScene = GameScene(size: gameView.frame.size)
        gameScene.name = "gameScene"
        gameScene.backgroundColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        gameScene.scaleMode = .AspectFill
        gameScene.gameViewController = self
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        gameView.presentScene(
            gameScene,
            transition: SKTransition.crossFadeWithDuration(5.0)
        )
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showEndGameView") {
            let endGameView = segue.destinationViewController as! EndGameViewController
            
            endGameView.finalGameTime = gameScene.gameCurrentTime
            
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        gameScene.paused = true
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        
        coder.encodeCGPoint(gameScene.icarus.position, forKey: "icarusPosition")
        coder.encodeInt32(gameScene.icarus.health, forKey: "icarusHealth")
        coder.encodeCGPoint(gameScene.sun.position, forKey: "sunPosition")
        coder.encodeBool(gameScene.gameJustBegan, forKey: "gameJustBeganValue")
        coder.encodeObject(gameScene.gameStartTime, forKey: "gameCurrentTime")
        coder.encodeBool(gameScene.paused, forKey: "gameScenePaused")
        coder.encodeInt32(global.difficultyLevel, forKey: "savedDifficultyLevel")
        
        super.encodeRestorableStateWithCoder(coder)
        
    }
    
    
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        
        gameScene.icarusStartPosition = coder.decodeCGPointForKey("icarusPosition")
        gameScene.icarusStartHealth = coder.decodeInt32ForKey("icarusHealth")
        gameScene.sunStartPosition = coder.decodeCGPointForKey("sunPosition")
        gameScene.gameJustBegan = coder.decodeBoolForKey("gameJustBeganValue")
        gameScene.gameStartTime = coder.decodeObjectForKey("gameCurrentTime") as! CFTimeInterval
        gameScene.paused = coder.decodeBoolForKey("gameScenePaused")
        global.difficultyLevel = coder.decodeInt32ForKey("savedDifficultyLevel")
        
        super.decodeRestorableStateWithCoder(coder)
        
    }
    
//  UIBUTTON FUNCTIONS  ------------------------------------------------------//
    
    @IBAction func pauseButtonPushed(sender: UIButton) {
        if !gamePausedWithAnimation {
            gamePausedWithAnimation = true
        }
        else {
            gamePausedWithAnimation = false
        }
        
        if gameScene.paused {
            gameScene.paused = false
        }
        
    }
    
    
    
}