//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class RoomAllResponse: Content {
    
    var id: UUID?
    var rooms: [RoomDTO]
    
    init(id: UUID? = nil, rooms: [RoomDTO]) {
        self.id = id
        self.rooms = rooms
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case rooms
    }
}
