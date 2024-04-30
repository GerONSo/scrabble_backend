//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class Turn: Model, Content {
    static let schema = "turns"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "room_id")
    var roomId: UUID
    
    @Field(key: "current_turn_user_id")
    var currentTurnUserId: UUID

    init() { }

    init(id: UUID? = nil, roomId: UUID, currentTurnUserId: UUID) {
        self.id = id
        self.roomId = roomId
        self.currentTurnUserId = currentTurnUserId
    }
}
