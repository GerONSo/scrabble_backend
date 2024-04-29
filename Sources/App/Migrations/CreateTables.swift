//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor
import FluentPostgresDriver

func createMigrations() -> Array<Migration> {
    return [CreateRooms(), CreateScores(), CreateTurns(), CreateUsers(), CreateWords()]
}

struct CreateRooms: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Room.schema)
            .id()
            .field("room_id", .string, .required)
            .field("invite_code", .string)
            .field("name", .string, .required)
            .field("admin_id", .string, .required)
            .field("started", .string, .required)
            .field("paused", .string, .required)
            .field("available_tiles", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Room.schema).delete()
    }
}

struct CreateScores: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Score.schema)
            .id()
            .field("room_id", .string, .required)
            .field("user_id", .string, .required)
            .field("score", .string, .required)
            .field("tiles", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Score.schema).delete()
    }
}

struct CreateTurns: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Turn.schema)
            .id()
            .field("room_id", .string, .required)
            .field("current_turn_user_id", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Turn.schema).delete()
    }
}

struct CreateUsers: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("user_id", .string, .required)
            .field("login", .string, .required)
            .field("password", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}

struct CreateWords: AsyncMigration {
    func prepare(on database: Database) async throws {
        let direction = try await database.enum("direction")
            .case(Word.Direction.Right.rawValue)
            .case(Word.Direction.Down.rawValue)
            .create()
        try await database.schema(Word.schema)
            .id()
            .field("room_id", .string, .required)
            .field("user_id", .string, .required)
            .field("word", .string, .required)
            .field("position_x", .string, .required)
            .field("position_y", .string, .required)
            .field("direction", direction, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Word.schema).delete()
    }
}
