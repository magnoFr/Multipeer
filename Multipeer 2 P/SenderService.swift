//
//  SenderService.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 31/01/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class SenderServiseManeger: NSObject {
    
    private let senderServiceType = "myString"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private var serviceAdviserAssistant: MCAdvertiserAssistant!
    
    lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    
    var delegate: SenderServiceManagerDelegate?
    var gameDelegate: GameDelegate?
    
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: senderServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: senderServiceType)
        super .init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        //        self.serviceBrowser.startBrowsingForPeers()
        
        //self.delegate = GameViewController()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    
    func sendCommand(command : String) {
        //NSLog("%@", "sendColor: \(command) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(command.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    func sendPlayer(player: Player){
        //NSLog("%@", "sendColor: \(player) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                print("BB")
                let dict: Dictionary<String, Player> = ["player": player]
                let encodeDict = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: true)
                try self.session.send(encodeDict, toPeers: session.connectedPeers, with: .reliable)
                
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    func host(){
        self.serviceAdviserAssistant = MCAdvertiserAssistant(serviceType: senderServiceType, discoveryInfo: nil, session: self.session)
        self.serviceAdviserAssistant.start()
        //self.gameDelegate?.createPlayer(pos: CGPoint(x: CGFloat(Int.random(in: 20...60)), y: CGFloat(Int.random(in: 20...60))), id: "001")
        
    }
    
    func join() -> MCBrowserViewController{
        let mcBrowser = MCBrowserViewController(serviceType: senderServiceType, session: self.session)
        mcBrowser.maximumNumberOfPeers = 1
        mcBrowser.delegate = self
        return mcBrowser
    }
    
    func disconect(){
        session.disconnect()
    }
    
    
    
}

extension SenderServiseManeger: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
    
}

extension SenderServiseManeger: MCNearbyServiceBrowserDelegate{
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //NSLog("%@", "foundPeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //NSLog("%@", "lostPeer: \(peerID)")
    }
    
    
}

extension SenderServiseManeger: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        //self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            //session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //NSLog("%@", "didReceiveData: \(data)")
        
        let pData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        let playerData = pData as? [String : Player]
        
        if "player" == playerData?.keys.first{
            self.delegate?.passPlayer(player: ((playerData?["player"])!))
            }
        else{
            let str = String(data: data, encoding: .utf8)
            print("A sessao", self.session.myPeerID.displayName)
            self.delegate?.command(maneger: self, action: str!, peerId: peerID.displayName)
        }
        
        print(session.connectedPeers)
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    
}

extension SenderServiseManeger: MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
         self.delegate?.dismissView(algo: "oi")
//        print(browserViewController.session.myPeerID)
        let x = CGFloat(Int.random(in: 0...200))
        let y = CGFloat(Int.random(in: 0...100))
        print(x,y)
        self.gameDelegate?.createPlayer(pos: CGPoint(x: x, y: y), id: session.myPeerID.displayName)
//        let x2 = CGFloat(Int.random(in: 200...300))
//        let y2 = CGFloat(Int.random(in: 0...100))
//        print(x2,y2)
//        self.gameDelegate?.createPlayer(pos: CGPoint(x: x2, y: y2), id: "002")
        
        for peer in browserViewController.session.connectedPeers{
            let x = CGFloat(Int.random(in: 200...300))
            let y = CGFloat(Int.random(in: 0...100))
            self.gameDelegate?.createPlayer(pos: CGPoint(x: x, y: y), id: peer.displayName)
            print(peer.displayName, x, y)
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.delegate?.dismissView(algo: "oi")
    }
    
    
}











