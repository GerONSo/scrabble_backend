//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor

final class RoomGetUsersResponse: Content {
    
    var id: UUID?
    var users: [UserDTO]
    
    init(id: UUID? = nil, users: [UserDTO]) {
        self.id = id
        self.users = users
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case users
    }
}
