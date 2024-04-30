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
    
    init(id: UUID? = nil, users: [UserDTO], adminUserId: UUID?) {
        self.id = id
        self.users = users
        self.adminUserId = adminUserId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case users
        case adminUserId = "admin_user_id"
    }
}
