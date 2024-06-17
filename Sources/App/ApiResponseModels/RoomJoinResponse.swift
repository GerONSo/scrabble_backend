//
//  File.swift
//  
//
//  Created by smgoncharov on 17.06.2024.
//

import Foundation
import Vapor

final class RoomJoinResponse: Content {
    var roomId: UUID?
    
    init(roomId: UUID?) {
        self.roomId = roomId
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
    }
}
