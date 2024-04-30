import Vapor
import Fluent
import JWTKit
import JWT

func routes(_ app: Application) throws {
    
    app.post("rooms", "create") { req async throws -> RoomCreateResponse in
        let request = try req.content.decode(RoomCreateRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        // add new room
        let newRoom = Room(
            name: request.roomName,
            inviteCode: InviteCodeGenerator.generate(),
            adminId: userId,
            started: false,
            paused: false,
            availableTiles: StaticData.allTiles
        )
        try await newRoom.create(on: req.db)
        
        // add admin
        
        let newScore = Score(
            roomId: newRoom.id!,
            userId: userId,
            score: "0",
            tiles: ""
        )
        try await newScore.create(on: req.db)
        
        return RoomCreateResponse(roomId: newRoom.id)
    }
    
//    app.get("rooms", "get_users") { req async throws -> RoomGetUsersResponse in
//        let request = try req.content.decode(RoomRequest.self)
//        
//        let a = try await req.db.query(Room.self).filter(\.$roomId == request.roomId)
//        return RoomGetUsersResponse(users: roomsChange.id)
//    }
    
    
    // MARK: -auth
    app.post("register") { req -> EventLoopFuture<User> in
        let userReq = try req.content.decode(UserReq.self)
        let user = User(id: UUID(), userId: UUID(), login: userReq.login, password: userReq.password)
        return user.save(on: req.db).map { user }
    }
    
    app.post("login") { req -> EventLoopFuture<String> in
        let userReq = try req.content.decode(UserReq.self)
//        let user = User(id: nil, userId: nil, login: userReq.login, password: userReq.password)
        
        return User.query(on: req.db)
            .filter(\.$login == userReq.login)
            .filter(\.$password == userReq.password)
            .first()
            .flatMapThrowing { user -> String in
                guard let user = user else {
                    throw Abort(.unauthorized)
                }
                
                let userToken = User.Payload(userId: user.userId)
                let jwt = try req.jwt.sign(userToken) // использовать метод sign у JWTSigner
//                let token = try jwt.sign()
    
                return jwt
            }
    }
    
    app.get("users") { req async throws in
        try await User.query(on: req.db).all()
    }
    
    // TODO remove
    app.get("galaxies") { req async throws in
        try await Galaxy.query(on: req.db).all()
    }
    // TODO remove
    app.post("galaxies") { req async throws -> Galaxy in
        let galaxy = try req.content.decode(Galaxy.self)
        try await galaxy.create(on: req.db)
        return galaxy
    }
}
