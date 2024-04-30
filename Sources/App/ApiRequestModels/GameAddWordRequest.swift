//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class GameAddWordRequest: Content {
    var roomId: String
    var userId: String
    var word: String
    var positionX: Int
    var positionY: Int
    var direction: Word.WordDirection
    var lettersUsed: String
    
    init(roomId: String, userId: String, word: String, positionX: Int, positionY: Int, direction: Word.WordDirection, lettersUsed: String) {
        self.roomId = roomId
        self.userId = userId
        self.word = word
        self.positionX = positionX
        self.positionY = positionY
        self.direction = direction
        self.lettersUsed = lettersUsed
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case userId = "user_id"
        case word
        case positionX = "position_x"
        case positionY = "position_y"
        case direction
        case lettersUsed = "letters_used"
    }
}
