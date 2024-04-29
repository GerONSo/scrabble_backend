//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor
import FluentPostgresDriver

final class RoomCreateRequest: Model {
    static let schema = "room_create"

    @ID(custom: "id")
    var id: UUID?
    @Field(key: "user_id")
    var userId: String
    @Field(key: "room_name")
    var roomName: String
    @Field(key: "is_private")
    var isPrivate: Bool
}
