//
//  GameScene.swift
//  IcarusGame
//
//  Created by Luke A Chase on 9/16/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene {
    
    var gameViewController: GameViewController!
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    var gameViewWidth: CGFloat!
    var gameViewHeight: CGFloat!
    var gameViewDistance: CGFloat!
    var gameViewHorizontalCenter: CGFloat!
    var gameViewVerticalCenter: CGFloat!
    
    var gameStartTime: CFTimeInterval!
    var gameCurrentTime: CFTimeInterval!
    var gameJustBegan: Bool = true
    var gameEnded: Bool = false
    
    var clouds = [Cloud]()
    
    let icarus = Hero(imageNamed: "Icarus")
    var icarusStartHealth: Int32?
    var icarusStartPosition: CGPoint?
    
    let sun = SKSpriteNode(imageNamed: "Sun")
    var sunStartPosition: CGPoint?
    
    var particleRange: CGFloat!
    var particleScale: CGFloat!
    
    var hitPointValue: Int32!
    var icarusMass: CGFloat!
    var icarusSpeedMultiplier: CGFloat!
    var sunSpeedMultiplier: CGFloat!
    
    // Arrays used for difficulty modes [easy, hard]:
    let difficultyModeHpValue: [Int32] = [4, 8]
    let difficultyModeIcarusMass: [CGFloat] = [0.01, 0.005]
    let difficultyModeIcarusSpeed: [CGFloat] = [10.0, 15.0]
    let difficultyModeSunSpeed: [CGFloat] = [10.0, 8.0]
    
    let global = Global()
    
//----------------------------------------------------------------------------//
    
    override func didMoveToView(view: SKView) {
        
        setDifficultyMode(global.difficultyLevel)
    
        setUpGame()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        motionManager.startAccelerometerUpdates()
        
        self.paused = false
        
    }
    
//  GAME SETUP FUNCTIONS  ----------------------------------------------------//
    
    func setDifficultyMode(level: Int32) {

        let index = Int(level)
        
        hitPointValue = difficultyModeHpValue[index]
        icarusMass = difficultyModeIcarusMass[index]
        icarusSpeedMultiplier = difficultyModeIcarusSpeed[index]
        sunSpeedMultiplier = difficultyModeSunSpeed[index]
            
    }
    
    
    
    func setUpGame() {
        
        gameViewWidth = self.frame.width
        gameViewHeight = self.frame.height
        gameViewDistance = sqrt(pow(gameViewWidth, 2) + pow(gameViewHeight, 2))
        gameViewHorizontalCenter = gameViewWidth / 2
        gameViewVerticalCenter = gameViewHeight / 2
        
        // SKEmitterNode sizes based on screen size
        particleRange = gameViewDistance / 25
        particleScale = gameViewDistance / 7500
        
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        ground.name = "ground"
        ground.size = CGSize(width: gameViewWidth * 1.25, height: gameViewHeight * 1.25)
        ground.position = CGPointMake(gameViewHorizontalCenter, gameViewVerticalCenter)
        ground.zPosition = 0
        
        self.addChild(ground)
        
        
        let initialRandomCloudNumber = Int(global.randomCGFloat(maxRange: 5, minRange: 3))
        
        for _ in 1...initialRandomCloudNumber {
            let cloud = newCloud()
            clouds.append(cloud)
            self.addChild(cloud)
        }
        
        
        icarus.name = "icarus"
        icarus.size = CGSize(width: gameViewHeight / 10, height: gameViewHeight / 10)
        if icarusStartPosition == nil {
            icarus.position = makeRandomPointWithinBounds(
                boundsWidth: gameViewWidth, boundsHeight: gameViewHeight,
                spriteWidth: icarus.size.width, spriteHeight: icarus.size.height)
        }
        else {
            icarus.position = icarusStartPosition!
        }
        icarus.zPosition = 10
        
        icarus.physicsBody = SKPhysicsBody(rectangleOfSize: icarus.frame.size)
        icarus.physicsBody!.dynamic = true
        icarus.physicsBody!.affectedByGravity = false
        icarus.physicsBody!.mass = icarusMass
        
        self.addChild(icarus)
        
        if icarusStartHealth == nil {
            icarus.health = 100
        }
        else {
            icarus.health = icarusStartHealth
        }
        
        
        let icarusGlow = SKEmitterNode(fileNamed: "Icarus.sks")!
        icarusGlow.name = "icarusGlow"
        icarusGlow.position = CGPointMake(0, 0)
        icarusGlow.zPosition = -1
        icarusGlow.particlePositionRange = CGVector(dx: particleRange, dy: particleRange)
        icarusGlow.particleScale = particleScale * (CGFloat(icarus.health) / 100)
        icarusGlow.particleScaleRange = particleScale * (CGFloat(icarus.health) / 100)
        icarusGlow.particleBirthRate = CGFloat(250 * (icarus.health / 100))
        
        icarus.addChild(icarusGlow)
        
        
        sun.name = "sun"
        if sunStartPosition == nil {
            repeat {
                sun.position = makeRandomPointWithinBounds(
                    boundsWidth: gameViewWidth, boundsHeight: gameViewHeight,
                    spriteWidth: gameViewWidth / 10, spriteHeight: gameViewHeight / 10)
            } while global.distanceBetweenNodes(node1: icarus, node2: sun) < gameViewDistance / 4
        }
        else {
            sun.position = sunStartPosition!
        }
        sun.zPosition = 11
        
        self.addChild(sun)
        
        
        let sunGlow = SKEmitterNode(fileNamed: "Sun.sks")!
        sunGlow.name = "sunGlow"
        sunGlow.position = CGPointMake(0, 0)
        sunGlow.zPosition = -1
        sunGlow.particlePositionRange = CGVector(dx: particleRange, dy: particleRange)
        sunGlow.particleScale = particleScale
        sunGlow.particleScaleRange = particleScale
        
        sun.addChild(sunGlow)
        
        gameViewController.currentHealth.text = "\(icarus.health)%"
        gameViewController.currentHealth.textColor = UIColor(
            red: 1 - (CGFloat(icarus.health) / 100),
            green: CGFloat(icarus.health) / 100,
            blue: 0,
            alpha: 1
        )
        
        
        self.runAction(SKAction.fadeInWithDuration(4.0))
        
    }
    
    
    
    func makeRandomPointWithinBounds(boundsWidth boundsWidth:CGFloat, boundsHeight:CGFloat, spriteWidth:CGFloat, spriteHeight:CGFloat) -> CGPoint {
        
        let x = global.randomCGFloat(
            maxRange: (boundsWidth - (spriteWidth / 2)),
            minRange: (spriteWidth / 2) + 1)
        
        let y = global.randomCGFloat(
            maxRange: (boundsHeight - (spriteHeight / 2)),
            minRange: (spriteHeight / 2) + 1)
        
        return CGPointMake(x, y)
        
    }
    
    
    
    func newCloud() -> Cloud {
        
        
        let cloudSize = gameViewWidth / global.randomCGFloat(maxRange: 2, minRange: 1)
        let randomCloudImageNumber = Int(global.randomCGFloat(maxRange: 4, minRange: 1))
        
        
        let cloud = Cloud(imageNamed: "Cloud-\(randomCloudImageNumber)")
        cloud.name = "cloud-\(randomCloudImageNumber)"
        cloud.size = CGSize(width: cloudSize, height: cloudSize / 1.867)
        cloud.position = makeRandomPointWithinBounds(
            boundsWidth: gameViewWidth,
            boundsHeight: gameViewHeight,
            spriteWidth: gameViewWidth / cloudSize,
            spriteHeight: gameViewHeight / cloudSize
        )
        cloud.zPosition = global.randomCGFloat(maxRange: 4, minRange: 2)
        
        
        let destinationPointY = global.randomCGFloat(maxRange: gameViewHeight, minRange: 0)
        
        var destinationPointX: CGFloat!
        
        // set end point across screen
        if cloud.position.x <= gameViewHorizontalCenter {
            destinationPointX = gameViewWidth + 10 + (cloud.size.width / 2)
        }
        else {
            destinationPointX = -10 - (cloud.size.width / 2)
        }
        
        cloud.destination = CGPointMake(destinationPointX, destinationPointY)
        
        
        return cloud
        
    }
//  END GAME SETUP FUNCTIONS  ------------------------------------------------//
    
//  MOTION DETECTION FUNCTIONS  ----------------------------------------------//
    
    func motionDetected() -> Bool {
        
        if let motionData = motionManager.accelerometerData {
            
            if (fabs(motionData.acceleration.x) > 0.01) || (fabs(motionData.acceleration.y) > 0.01) {
                return true
            }
            
        }
        
        return false
        
    }
    
    
    
    func icarusWithinBoundsX() -> Bool {
        
        return icarus.position.x > (icarus.size.width / 2) + 10
            && icarus.position.x < gameViewWidth - (icarus.size.width / 2) - 10
        
    }
    
    
    
    func icarusWithinBoundsY() -> Bool {
        
        return icarus.position.y > (icarus.size.height / 2) + 10
            && icarus.position.y < gameViewHeight - (icarus.size.width / 2) - 10
        
    }
    
//  END MOTION DETECTION FUNCTIONS  ------------------------------------------//

//  MOTION UPDATE FUNCTIONS  -------------------------------------------------//
    
    func moveGround() {
        
        if motionDetected() {
            
            let motionData = motionManager.accelerometerData!
            
            let ground = childNodeWithName("ground") as! SKSpriteNode
            
            let groundHorizontalOverflowSize = ((ground.size.width - gameViewWidth) / 2) + 1
            let groundVerticalOverflowSize = ((ground.size.height - gameViewHeight) / 2) + 1
            
            if icarusWithinBoundsX() {
                
                if ground.position.x > gameViewHorizontalCenter - groundHorizontalOverflowSize
                    && ground.position.x < gameViewHorizontalCenter + groundHorizontalOverflowSize {
                        
                        ground.position.x -= CGFloat(motionData.acceleration.y) * 2
                        
                }
                else {
                    
                    ground.position.x += CGFloat(motionData.acceleration.y)
                    
                }
                
            }
            
            if icarusWithinBoundsY() {
                
                if ground.position.y > gameViewVerticalCenter - groundVerticalOverflowSize
                    && ground.position.y < gameViewVerticalCenter + groundVerticalOverflowSize {
                        
                        ground.position.y += CGFloat(motionData.acceleration.x) * 2
                        
                }
                else {
                    
                    ground.position.y -= CGFloat(motionData.acceleration.x)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func moveClouds() {
        
        for (index, cloud) in clouds.enumerate() {
            
            let cloudSpeed = cloud.distanceToDestination() / gameViewDistance * global.randomCGFloat(maxRange: 70, minRange: 50)
            
            if motionDetected() {
                
                let motionData = motionManager.accelerometerData!
                let zPositionMultiplier = global.randomCGFloat(maxRange: 2.0, minRange: 1.25)
                
                if icarusWithinBoundsX() {
                    if cloud.position.x < gameViewHorizontalCenter {
                        
                        cloud.position.x -= CGFloat(motionData.acceleration.y) * zPositionMultiplier * 1.5
                        
                    }
                    else {
                        
                        cloud.position.x += CGFloat(motionData.acceleration.y) * zPositionMultiplier * 1.5
                        
                    }
                }
                
                if icarusWithinBoundsY() {
                    if cloud.position.y < gameViewVerticalCenter {
                        
                        cloud.position.y += CGFloat(motionData.acceleration.x) * zPositionMultiplier * 0.5
                        
                    }
                    else {
                        
                        cloud.position.y -= CGFloat(motionData.acceleration.x) * zPositionMultiplier * 0.5
                        
                    }
                }
                
            }
            else {
                
                cloud.runAction(
                    SKAction.moveTo(
                        cloud.destination,
                        duration: NSTimeInterval(cloudSpeed)
                    )
                )
                
                if cloud.position == cloud.destination {
                    cloud.removeAllActions()
                    cloud.removeFromParent()
                    clouds.removeAtIndex(index)
                }
            
            }
            
        }
        
    }
    
    
    
    func checkClouds() {
        
        if clouds.count <= 5 {
            
            let cloud = newCloud()
            
            // ensures clouds created during gameplay come in from
            // outside the viewable screen so they don't just appear
            if cloud.position.x <= gameViewHorizontalCenter {
                cloud.position.x = -10 - (cloud.size.width / 2)
            }
            else {
                cloud.position.x = gameViewWidth + 10 + (cloud.size.width / 2)
            }
            
            clouds.append(cloud)
            self.addChild(cloud)
            
        }
        
    }
    
    
    func moveIcarus() {
        
        let icarus = childNodeWithName("icarus")!
        icarus.paused = false
        
        
        if motionDetected() {
            
            let motionData = motionManager.accelerometerData
            
            icarus.physicsBody!.applyForce(CGVectorMake(icarusSpeedMultiplier * CGFloat(motionData!.acceleration.y), 0))
            icarus.physicsBody!.applyForce(CGVectorMake(0, -icarusSpeedMultiplier * CGFloat(motionData!.acceleration.x)))
            
        }
        
    }
    
    
    
    func moveSun() {
        let icarus = childNodeWithName("icarus")!
        let sun = childNodeWithName("sun")!
        
        // SKAction.moveTo: <duration> set as constant makes sun slow as it
        // gets closer to icarus; my formula ensures the sun speed is steady
        let distanceBetweenNodesPercentage = global.distanceBetweenNodes(node1: icarus, node2: sun) / gameViewDistance
        let sunSpeed = sunSpeedMultiplier * distanceBetweenNodesPercentage
        
        // increase sun speed as sun gets closer to icarus
        var sunSpeedDivisor: CGFloat!
        switch distanceBetweenNodesPercentage {
        case 0..<0.1:
            sunSpeedDivisor = 2.0
        case 0.1..<0.12:
            sunSpeedDivisor = 1.8
        case 0.12..<0.14:
            sunSpeedDivisor = 1.6
        case 0.14..<0.16:
            sunSpeedDivisor = 1.4
        case 0.16..<0.18:
            sunSpeedDivisor = 1.2
        default:
            sunSpeedDivisor = 1
        }
        
        
        sun.runAction(
            SKAction.moveTo(
                icarus.position,
                duration:NSTimeInterval(sunSpeed / sunSpeedDivisor)
            )
        )
        
    }

//  END MOTION UPDATE FUNCTIONS  ---------------------------------------------//
    
//  SOFT PAUSE FUNCTIONS  ---------------------------------------------------//
    
    func pauseIcarus() {
        
        self.physicsWorld.speed = 0.0
        
    }
    
    
    
    func pauseSun() {
        let sun = childNodeWithName("sun")!
        
        sun.removeAllActions()
        
    }
    
    
    
    func pauseTimer(currentTime: CFTimeInterval) {
        
        gameStartTime = currentTime - gameCurrentTime
        
    }
    
//  END SOFT PAUSE FUNCTIONS  ------------------------------------------------//
    
//  GAME UPDATE FUNCTIONS  ---------------------------------------------------//
    
    func checkCollisions() {
        
        let icarus = self.childNodeWithName("icarus") as! Hero
        let sun = self.childNodeWithName("sun")!
        
        
        if (icarus.intersectsNode(sun)) {
            
            icarus.updateHealth(hitPoints: hitPointValue)
            updateIcarusGlow(health: icarus.health)
            
            gameViewController.currentHealth.text = "\(icarus.health)%"
            gameViewController.currentHealth.textColor = UIColor(
                red: 1 - (CGFloat(icarus.health) / 100),
                green: CGFloat(icarus.health) / 100,
                blue: 0,
                alpha: 1
            )
            
            
            if icarus.health <= 0 {
            
                gameEnded = true
                
                let explosion = SKEmitterNode(fileNamed: "Explosion")!
                explosion.position = icarus.position
                explosion.zPosition = 11
                
                self.addChild(explosion)
                
                
                icarus.removeFromParent()
                sun.removeFromParent()
                
                
                explosion.runAction(
                    SKAction.sequence([
                        SKAction.fadeOutWithDuration(4.0),
                        SKAction.removeFromParent()
                    ])
                )

                
                self.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(4.0),
                        SKAction.runBlock {
                            self.removeAllChildren()
                            self.removeFromParent()
                            self.presentView(nameOfView: "showEndGameView")
                        }
                    ])
                )
                
            }
            
        }
        
    }
    
    
    
    func updateIcarusGlow(health health: Int32) {
        
        let icarusGlow = icarus.childNodeWithName("icarusGlow") as! SKEmitterNode
        
        icarusGlow.particlePositionRange = CGVectorMake(
            particleRange * (CGFloat(health) / 100),
            particleRange * (CGFloat(health) / 100)
        )
        icarusGlow.particleScale = particleScale * (CGFloat(health) / 100)
        icarusGlow.particleScaleRange = particleScale * (CGFloat(health) / 100)
        icarusGlow.particleColorBlueSpeed = CGFloat(health) / 100
        
    }
    
    
    
    func presentView (nameOfView nameOfView: String) {
        
        self.gameViewController.performSegueWithIdentifier(nameOfView, sender: self)
        self.gameViewController.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        
        if gameJustBegan {
            gameStartTime = currentTime
            gameJustBegan = false
        }
        
        
        if !gameEnded {
            
            if gameViewController.gamePausedWithAnimation {
                
                pauseIcarus()
                pauseSun()
                pauseTimer(currentTime)
                self.gameViewController.gameCurrentTimeLabel.text = "Game Paused"
                return
                
            }
            else {
                
                self.physicsWorld.speed = 1.0
                
                gameCurrentTime = currentTime - gameStartTime
                
                self.gameViewController.gameCurrentTimeLabel.text = "[\(global.timeString(gameCurrentTime))]"
                
                moveGround()
                
                moveClouds()
                
                checkClouds()
                
                moveIcarus()
                
                moveSun()
                
                checkCollisions()
                
            }
            
        }
        
    }
    
//  END GAME UPDATE FUNCTIONS  -----------------------------------------------//
    
}
