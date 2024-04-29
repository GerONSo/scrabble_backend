//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor
import FluentPostgresDriver

final class RoomCreateResponse: Content {
    static let schema = "room_create"
    
    var id: UUID?
    
    init(roomId: UUID?) {
        self.id = roomId
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
    }
}
