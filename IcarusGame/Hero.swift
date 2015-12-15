//
//  Hero.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/18/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import SpriteKit


class Hero : SKSpriteNode {
    
    var health: Int32!
    
//----------------------------------------------------------------------------//
    
    convenience init() {
        self.init(imageNamed: "")
    }
    
    override init(texture: SKTexture!, color: (UIColor!), size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//  HEALTH FUNCTIONS  --------------------------------------------------------//
    
    func initialHealth(value value: Int32) {
        
        self.health = value
        
    }
    
    
    
    func updateHealth(hitPoints hitPoints: Int32) {
        
        if self.health != nil {
            
            health = health - hitPoints < 0 ? 0 : health - hitPoints
            
        }
    }
    
}
