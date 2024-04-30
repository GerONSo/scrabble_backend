//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

struct RoomDTO: Content {
    var id: UUID?
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
