//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor

final class RoomGetUsersResponse: Content {
    
    var id: UUID?
    var users: [UserDTO]
    var adminUserId: UUID?
    var roomName: String
    var inviteCode: String?
    
    init(id: UUID? = nil, users: [UserDTO], adminUserId: UUID?, roomName: String, inviteCode: String? = nil) {
        self.id = id
        self.users = users
        self.adminUserId = adminUserId
        self.roomName = roomName
        self.inviteCode = inviteCode
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case users
        case adminUserId = "admin_user_id"
        case roomName = "room_name"
        case inviteCode = "invite_code"
    }
}
