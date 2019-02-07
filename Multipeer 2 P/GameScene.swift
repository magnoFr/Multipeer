//
//  GameScene.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 26/01/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameScene: SKScene{

    var players: [Player] = []
    
    var gameVC = GameViewController()
    
    
    
    override func didMove(to view: SKView) {
        gameVC.senderServise.gameDelegate = self
        gameVC.gameSceneDelegate = self
        //players.append(Player(position: CGPoint(x: 0, y: 0), playerId: "123", parent: self))
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("hi")
            //gameVC?.dismissView(algo: "keke")
        
        }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}

extension GameScene: GameDelegate{
    func createPlayer(pos: CGPoint, id: String) {
        print("criando player")
        print("preparando para aplicar as posicoes", pos)
        self.players.append(Player(position: pos, playerId: id, parent: self))
        print("hayaa")
        gameVC.senderServise.sendPlayer(player: players.last!)
        
        
        
    }
    
    
}




