//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor

final class RoomRequest: Content {
    var roomId: String
    
    init(roomId: String) {
        self.roomId = roomId
    }
}
