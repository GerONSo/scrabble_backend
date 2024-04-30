import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    app.post("rooms", "create") { req async throws -> RoomCreateResponse in
        let request = try req.content.decode(RoomCreateRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        // add new room
        let newRoom = Room(
            name: request.roomName,
            inviteCode: request.isPrivate ? InviteCodeGenerator.generate() : nil,
            adminId: userId,
            started: false,
            paused: false,
            availableTiles: StaticData.allTiles
        )
        try await newRoom.create(on: req.db)
        let newRoomId = newRoom.id
        
        // add admin
        
        let newScore = Score(
            roomId: newRoom.id!,
            userId: userId,
            score: "0",
            tiles: ""
        )
        try await newScore.create(on: req.db)
        
        return RoomCreateResponse(roomId: newRoomId)
    }
    
    app.get("rooms", "get_users") { req async throws -> RoomGetUsersResponse in
        let request = try req.content.decode(RoomRequest.self)
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        let users: [UserDTO] = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .join(User.self, on: \User.$userId == \Score.$userId)
            .all()
            .map {
                let login = try $0.joined(User.self).login
                return UserDTO(id: $0.userId, name: login)
            }
        let adminId: UUID? = try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .field(\.$adminId)
            .first()
            .map {
                $0.adminId
            }
        return RoomGetUsersResponse(users: users, adminUserId: adminId)
    }
    
    app.post("rooms", "join") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomJoinRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        let newScore = Score(
            roomId: roomId,
            userId: userId,
            score: "0",
            tiles: ""
        )
        try await newScore.create(on: req.db)
        
        return DefaultResponse(success: true)
    }
    
    app.post("rooms", "kick") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomKickRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .filter(\.$userId == userId)
            .delete()
        
        return DefaultResponse(success: true)
    }
    
    app.post("rooms", "start") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .set(\.$started, to: true)
            .update()
        
        return DefaultResponse(success: true)
    }
    
    app.post("rooms", "pause") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .set(\.$paused, to: true)
            .update()
        
        return DefaultResponse(success: true)
    }
    
    app.post("rooms", "unpause") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .set(\.$paused, to: false)
            .update()
        
        return DefaultResponse(success: true)
    }
    
    app.post("rooms", "close") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .delete()
        
        try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .delete()
        
        return DefaultResponse(success: true)
    }
    
    app.get("rooms", "all") { req async throws -> RoomAllResponse in
        
        let allRooms: [RoomDTO] = try await req.db.query(Room.self)
            .filter(\.$inviteCode == .null)
            .filter(\.$started == false)
            .field(\.$name)
            .all()
            .map {
                RoomDTO(name: $0.name)
            }
        
        return RoomAllResponse(rooms: allRooms)
    }
}
