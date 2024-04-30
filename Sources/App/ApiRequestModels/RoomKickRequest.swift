//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class RoomKickRequest: Content {
    var roomId: String
    var userId: String
    
    init(roomId: String, userId: String) {
        self.roomId = roomId
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case userId = "user_id"
    }
}
