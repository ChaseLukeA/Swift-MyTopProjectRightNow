//
//  Cloud.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/17/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import SpriteKit


class Cloud : SKSpriteNode {
    
    var destination: CGPoint!
    
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
    
//  DISTANCE FUNCTIONS  ------------------------------------------------------//
    
    func distanceToDestination() -> CGFloat {
        
        return sqrt(pow((self.position.x - (self.destination.x)), 2) + pow((self.position.y - (self.destination.y)), 2))
        
    }
    
}