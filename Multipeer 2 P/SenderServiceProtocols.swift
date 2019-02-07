//
//  SenderServiceProtocols.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 31/01/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SenderServiceManagerDelegate {
    func dismissView(algo: String)
    func command(maneger: SenderServiseManeger, action: String, peerId: String)
    func passPlayer(player:Player)
}
