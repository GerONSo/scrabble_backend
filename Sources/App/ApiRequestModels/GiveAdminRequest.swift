//
//  File.swift
//  
//
//  Created by smgoncharov on 17.06.2024.
//

import Foundation
import Vapor

final class GiveAdminRequest: Content {
    var userId: String
    var roomId: String
    
    init(userId: String, roomId: String) {
        self.userId = userId
        self.roomId = roomId
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case roomId = "room_id"
    }
}
