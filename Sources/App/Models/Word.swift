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
    var positionX: Int
    
    @Field(key: "position_y")
    var positionY: Int
    
    @Enum(key: "direction")
    var direction: WordDirection
    
    init() { }

    init(id: UUID? = nil, roomId: UUID, userId: UUID, word: String, positionX: Int, positionY: Int, direction: WordDirection) {
        self.id = id
        self.roomId = roomId
        self.userId = userId
        self.word = word
        self.positionX = positionX
        self.positionY = positionY
        self.direction = direction
    }
    
    enum WordDirection: String, Codable, Equatable {
        case Right = "r"
        case Down = "d"
    }
}
