//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class GameStateResponse: Content {
    
    var tilesLeft: Int?
    var adminUserId: UUID?
    var users: [UserDTO]
    var desk: String?
    var availableTiles: String?
    var startTimer: Bool
    var currentTurnUserId: UUID?
    
    init(tilesLeft: Int?, adminUserId: UUID?, users: [UserDTO], desk: String?, availableTiles: String?, startTimer: Bool, currentTurnUserId: UUID?) {
        self.tilesLeft = tilesLeft
        self.adminUserId = adminUserId
        self.users = users
        self.desk = desk
        self.availableTiles = availableTiles
        self.startTimer = startTimer
        self.currentTurnUserId = currentTurnUserId
    }
    
    enum CodingKeys: String, CodingKey {
        case tilesLeft = "tiles_left"
        case adminUserId = "admin_user_id"
        case users
        case desk
        case availableTiles = "available_tiles"
        case startTimer = "start_timer"
        case currentTurnUserId = "current_turn_user_id"
    }
}
