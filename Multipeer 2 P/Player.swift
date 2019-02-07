//
//  Player.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 27/01/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import MultipeerConnectivity
import Foundation
import SpriteKit


public class Player: NSObject, NSCoding, NSSecureCoding{
    public static var supportsSecureCoding: Bool{
        return true
    }
    
    
    
    var shape: SKSpriteNode?
    var playerId: String?
    
//    public init(position: CGPoint, playerId: String ,parent: SKNode?) {
//
//        shape = SKSpriteNode(imageNamed: "player")
//        shape?.position = position
//        shape?.zPosition = 2
//        shape?.size = CGSize(width: 120, height: 125)
//
//        if (parent != nil){
//            parent?.addChild(self.shape!)
//        }
//
//        self.playerId = playerId
//    }
    
    required convenience public init(coder decoder: NSCoder) {
        self.init()
        self.playerId = decoder.decodeObject(forKey: "playerId") as? String
        self.shape = decoder.decodeObject(forKey: "shape") as? SKSpriteNode
    }
    
    convenience init(position: CGPoint, playerId: String ,parent: SKNode?) {
        self.init()
        shape = SKSpriteNode(imageNamed: "player")
        shape?.position.x = position.x
        shape?.position.y = position.y
        print("A posicao eh", position.x, position)
        shape?.zPosition = 2
        shape?.size = CGSize(width: 120, height: 125)
        
        if (parent != nil){
            parent?.addChild(self.shape!)
        }
        
        self.playerId = playerId
    }
    
    public func encode(with aCoder: NSCoder) {
        if let playerId = playerId { aCoder.encode(playerId, forKey: "playerId") }
        if let shape = shape { aCoder.encode(shape, forKey: "shape") }
    }
    
    
    func jump(){
        let sequence = SKAction.sequence([SKAction.moveBy(x: 0, y: 20, duration: 0.2),SKAction.moveBy(x: 0, y: -20, duration: 0.2)])
        self.shape?.run(sequence)
    }
    
    
}
