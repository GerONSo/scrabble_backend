//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class Score: Model, Content {
    static let schema = "scores"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "room_id")
    var roomId: UUID
    
    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "score")
    var score: String
    
    @Field(key: "tiles")
    var tiles: String
    
    init() { }

    init(id: UUID? = nil, roomId: UUID, userId: UUID, score: String, tiles: String) {
        self.id = id
        self.roomId = roomId
        self.userId = userId
        self.score = score
        self.tiles = tiles
        
    }
}
