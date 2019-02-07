//
//  GameViewController.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 26/01/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Foundation

class GameViewController: UIViewController {
    
    var senderServise = SenderServiseManeger()
    var gameSceneDelegate: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                let gameScene = scene as! GameScene
                gameScene.scaleMode = .aspectFill
                gameScene.gameVC = self
                
                
                // Present the scene
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        senderServise.delegate = self
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func showConnectivityActions(_ sender: Any) {
        let actionSheet = UIAlertController(title: "ToDo Exchange", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { (action:UIAlertAction) in
            self.senderServise.host()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { (action:UIAlertAction) in
            self.present(self.senderServise.join(), animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Disconect", style: .default, handler: { (action:UIAlertAction) in
            self.senderServise.disconect()
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func jumpTapped(_ sender: Any) {
        self.jump()
        senderServise.sendCommand(command: "jump")
    }
    
    func jump(){
        for (i, player) in (gameSceneDelegate?.players.enumerated())!{
            if player.playerId == self.senderServise.session.myPeerID.displayName {
                print(player.playerId as Any, self.senderServise.session.myPeerID.displayName)
                gameSceneDelegate?.players[i].jump()
            }
        }
    }
    
    
}

extension GameViewController: SenderServiceManagerDelegate{
    
    func passPlayer(player: Player) {
        print("dando certo")
        self.gameSceneDelegate?.addChild(player.shape!)
        self.gameSceneDelegate?.players.append(player)
    }
    
    func command(maneger: SenderServiseManeger, action: String, peerId: String) {
        if action == "jump"{
            print("ah chave eh", peerId)
            for (i, player) in (gameSceneDelegate?.players.enumerated())!{
                if player.playerId == peerId {
                    gameSceneDelegate?.players[i].jump()
                }
            }
        }
    }
    
    func dismissView(algo: String) {
        self.dismiss(animated: true, completion: nil)
    }
}
