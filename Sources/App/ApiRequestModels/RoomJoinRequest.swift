//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class RoomJoinRequest: Content {
    var roomId: String
    var userId: String
    var inviteCode: String?
    
    init(roomId: String, userId: String, inviteCode: String? = nil) {
        self.roomId = roomId
        self.userId = userId
        self.inviteCode = inviteCode
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case userId = "user_id"
        case inviteCode = "invite_code"
    }
}
