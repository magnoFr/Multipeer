//
//  GameProtocol.swift
//  Multipeer 2 P
//
//  Created by Magno Augusto Ferreira Ruivo on 01/02/19.
//  Copyright © 2019 Magno Augusto Ferreira Ruivo. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameDelegate {
    func createPlayer(pos: CGPoint, id: String)
}
