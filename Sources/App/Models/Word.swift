//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class Word: Model, Content {
    static let schema = "words"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "room_id")
    var roomId: UUID
    
    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "word")
    var word: String
    
    @Field(key: "position_x")
    var positionX: String
    
    @Field(key: "position_y")
    var positionY: String
    
    @Enum(key: "direction")
    var direction: Direction
    
    init() { }

    init(id: UUID? = nil, roomId: UUID, userId: UUID, word: String, positionX: String, positionY: String, direction: Direction) {
        self.id = id
        self.roomId = roomId
        self.userId = userId
        self.word = word
        self.positionX = positionX
        self.positionY = positionY
        self.direction = direction
    }
    
    enum Direction: String, Codable, Equatable {
        case Right = "r"
        case Down = "d"
    }
}
