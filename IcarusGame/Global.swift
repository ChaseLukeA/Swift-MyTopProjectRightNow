//
//  Global.swift
//  IcarusGame
//
//  Created by Luke A Chase on 10/11/15.
//  Copyright © 2015 chase.luke.a. All rights reserved.
//

import Foundation
import SpriteKit


class Global {
    
    static let sharedInstance = Global()
    
    var difficultyLevel: Int32 = 0
    
//  GLOBAL FUNCTIONS  --------------------------------------------------------//
    
    func timeString (time: CFTimeInterval) -> String {
        
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        
        return String(format: "%02i:%02i:%02i", minutes, Int(seconds), Int(secondsFraction * 100))
        
    }
    
    
    
    func randomCGFloat(maxRange maxRange:CGFloat, minRange:CGFloat) -> CGFloat {
        
        return CGFloat(arc4random_uniform(UInt32(maxRange)) + UInt32(minRange))
        
    }
    
    
    
    func distanceBetweenPoints (point1 point1: CGPoint, point2: CGPoint) -> CGFloat {
        
        return sqrt(pow((point1.x - point2.x), 2) + pow((point1.y - point2.y), 2))
        
    }
    
    
    
    func distanceBetweenNodes (node1 node1: SKNode, node2: SKNode) -> CGFloat {
        
        return sqrt(pow((node1.position.x - node2.position.x), 2) + pow((node1.position.y - node2.position.y), 2))
        
    }
    
}