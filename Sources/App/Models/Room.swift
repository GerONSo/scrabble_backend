//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class Room: Model, Content {

    static let schema = "rooms"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "room_id")
    var roomId: String
    
    @Field(key: "invite_code")
    var inviteCode: String?
    
    @Field(key: "admin_id")
    var adminId: UUID
    
    @Field(key: "started")
    var started: Bool
    
    @Field(key: "paused")
    var paused: Bool
    
    @Field(key: "available_tiles")
    var availableTiles: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        roomId: String = "",
        inviteCode: String?,
        adminId: UUID,
        started: Bool,
        paused: Bool,
        availableTiles: String
    ) {
        self.id = id
        self.name = name
        self.roomId = roomId
        self.inviteCode = inviteCode
        self.adminId = adminId
        self.started = started
        self.paused = paused
        self.availableTiles = availableTiles
    }
}
