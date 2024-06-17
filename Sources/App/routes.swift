import Vapor
import Fluent
import JWTKit
import JWT
//import CVaporBcrypt
import BCrypt
func routes(_ app: Application) throws {
    
    let auth = app.grouped(User.Payload.authenticator(), User.Payload.guardMiddleware())
    auth.post("rooms", "create") { req async throws -> RoomCreateResponse in
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
    
    auth.post("rooms", "get_users") { req async throws -> RoomGetUsersResponse in
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
        let roomName: String? = try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .first()?.name
        let inviteCode: String? = try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .first()?.inviteCode
        return RoomGetUsersResponse(users: users, adminUserId: adminId, roomName: roomName!, inviteCode: inviteCode)
    }
    
    auth.post("rooms", "join") { req async throws -> RoomJoinResponse in
        let request = try req.content.decode(RoomJoinRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        if (request.roomId == nil && request.inviteCode != nil) {
            guard let roomId = try await req.db.query(Room.self)
                .filter(\.$inviteCode == request.inviteCode)
                .first() else {
                return RoomJoinResponse(roomId: nil)
            }
            let newScore = Score(
                roomId: roomId.id!,
                userId: userId,
                score: "0",
                tiles: ""
            )
            try await newScore.create(on: req.db)
            return RoomJoinResponse(roomId: roomId.id!)
        }
        guard let roomId = request.roomId?.toUUID() else {
            throw Abort(.badRequest)
        }
        
        let newScore = Score(
            roomId: roomId,
            userId: userId,
            score: "0",
            tiles: ""
        )
        try await newScore.create(on: req.db)
        
        return RoomJoinResponse(roomId: roomId)
    }
    
    auth.post("rooms", "kick") { req async throws -> DefaultResponse in
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
        
        let roomUsersCount = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .all().count
        if (roomUsersCount == 0) {
            try await req.db.query(Score.self)
                .filter(\.$roomId == roomId)
                .delete()
            
            try await req.db.query(Room.self)
                .filter(\.$id == roomId)
                .delete()
            
            try await req.db.query(Turn.self)
                .filter(\.$roomId == roomId)
                .delete()
            
            try await req.db.query(Word.self)
                .filter(\.$roomId == roomId)
                .delete()
        }
        
        return DefaultResponse(success: true)
    }
    
    auth.post("rooms", "delete") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .delete()
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .delete()
        
        try await req.db.query(Turn.self)
            .filter(\.$roomId == roomId)
            .delete()
        
        try await req.db.query(Word.self)
            .filter(\.$roomId == roomId)
            .delete()
        
        return DefaultResponse(success: true)
    }
    
    auth.post("rooms", "give_admin") { req async throws -> DefaultResponse in
        let request = try req.content.decode(GiveAdminRequest.self)
        
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .set(\.$adminId, to: userId)
            .filter(\.$id == roomId)
            .update()
        
        return DefaultResponse(success: true)
    }
    
    auth.post("rooms", "start") { req async throws -> DefaultResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .set(\.$started, to: true)
            .update()
        guard let firstUserId = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .field(\.$userId)
            .first()?.userId else {
            throw Abort(.internalServerError)
        }
        
        let newTurn = Turn(
            roomId: roomId,
            currentTurnUserId: firstUserId
        )
        try await newTurn.create(on: req.db)
        
        return DefaultResponse(success: true)
    }
    
    auth.post("rooms", "pause") { req async throws -> DefaultResponse in
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
    
    auth.post("rooms", "unpause") { req async throws -> DefaultResponse in
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
    
    auth.post("rooms", "close") { req async throws -> DefaultResponse in
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
    
    auth.post("rooms", "scoreboard") { req async throws -> ScoreboardResponse in
        let request = try req.content.decode(RoomRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        let scoreboard: [ScoreboardDTO] = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .join(User.self, on: \User.$userId == \Score.$userId)
            .all()
            .map {
                let login = try $0.joined(User.self).login
                return ScoreboardDTO(name: login, score: $0.score)
            }
        
        return ScoreboardResponse(scoreboard: scoreboard)
    }
    
    auth.get("rooms", "all") { req async throws -> RoomAllResponse in
        
        let allRooms: [RoomDTO] = try await req.db.query(Room.self)
            .filter(\.$inviteCode == .null)
            .filter(\.$started == false)
            .field(\.$name)
            .field(\.$id)
            .all()
            .map {
                RoomDTO(id: $0.id, name: $0.name)
            }
        
        return RoomAllResponse(rooms: allRooms)
    }
    
    app.post("game", "add_word") { req async throws -> DefaultResponse in
        let request = try req.content.decode(GameAddWordRequest.self)
        
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        let lettersUsed = request.lettersUsed.uppercased()
        
        guard var availableTiles = try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .field(\.$availableTiles)
            .first()?.availableTiles else {
            throw Abort(.internalServerError)
        }
        
        guard var userTiles = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .filter(\.$userId == userId)
            .field(\.$tiles)
            .first()?.tiles else {
            throw Abort(.internalServerError)
        }
        userTiles = userTiles.removeLetters(letters: lettersUsed)
        let newLetters = availableTiles.getRandomLetters(n: lettersUsed.count)
        userTiles.append(newLetters)
        availableTiles = availableTiles.removeLetters(letters: newLetters)
        
        try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .set(\.$availableTiles, to: availableTiles)
            .update()
        
        var score = 0
        for l in lettersUsed {
            let index = StaticData.fieldMap.index(StaticData.fieldMap.startIndex, offsetBy: request.positionX * 15 + request.positionY)
            score += StaticData.tileCost[String(l)]! * StaticData.fieldMap[index].wholeNumberValue!
        }
        try await req.db.query(Score.self)
            .filter(\.$id == roomId)
            .filter(\.$userId == userId)
            .set(\.$tiles, to: userTiles)
            .set(\.$score, to: String(score))
            .update()
        
        let newWord = Word(
            roomId: roomId,
            userId: userId,
            word: request.word,
            positionX: request.positionX,
            positionY: request.positionY,
            direction: request.direction
        )
        try await newWord.create(on: req.db)
        
        let users = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .all()
        let currentUserId = try await req.db.query(Turn.self)
            .filter(\.$roomId == roomId)
            .first()
        let currentIndex = users.firstIndex {
            $0.userId == currentUserId?.currentTurnUserId
        }
        let nextIndex = currentIndex == users.index(before: users.endIndex) ? users.startIndex : users.index(after: currentIndex!)
        let currentTurnUserId = users[nextIndex].userId
        
        try await req.db.query(Turn.self)
            .filter(\.$roomId == roomId)
            .set(\.$currentTurnUserId, to: currentTurnUserId)
            .update()
        
        return DefaultResponse(success: true)
    }
    
    app.get("game", "state") { req async throws -> GameStateResponse in
        let request = try req.content.decode(GameStateRequest.self)
        guard let roomId = request.roomId.toUUID() else {
            throw Abort(.badRequest)
        }
        guard let userId = request.userId.toUUID() else {
            throw Abort(.badRequest)
        }
        
        let roomInfo = try await req.db.query(Room.self)
            .filter(\.$id == roomId)
            .first()
        
        let users: [UserDTO] = try await req.db.query(Score.self)
            .filter(\.$roomId == roomId)
            .join(User.self, on: \User.$userId == \Score.$userId)
            .all()
            .map {
                let login = try $0.joined(User.self).login
                return UserDTO(id: $0.userId, name: login)
            }
        let currentUserId = try await req.db.query(Turn.self)
            .filter(\.$roomId == roomId)
            .first()
        let gameState = try await req.db.query(Word.self)
            .filter(\.$roomId == roomId)
            .all()
        var state = StaticData.fieldMap
        for word in gameState {
            if (word.direction == .Right) {
                for i in 0..<word.word.count {
                    let wordIndex = word.word.index(word.word.startIndex, offsetBy: i)
                    let position = state.index(state.startIndex, offsetBy: word.positionX * 15 + word.positionY + i)
                    state.remove(at: position)
                    state.insert(word.word[wordIndex], at: position)
                }
            } else {
                for i in 0..<word.word.count {
                    let wordIndex = word.word.index(word.word.startIndex, offsetBy: i)
                    let position = state.index(state.startIndex, offsetBy: word.positionX * 15 + word.positionY + i * 15)
                    state.remove(at: position)
                    state.insert(word.word[wordIndex], at: position)
                }
            }
        }
        
        return GameStateResponse(
            tilesLeft: roomInfo?.availableTiles.count,
            adminUserId: roomInfo?.adminId,
            users: users,
            desk: state,
            availableTiles: roomInfo?.availableTiles,
            startTimer: false,
            currentTurnUserId: currentUserId?.currentTurnUserId
        )
    }

    // MARK: -auth
    app.post("register") { req -> EventLoopFuture<User> in
        let userReq = try req.content.decode(UserReq.self)
        guard let hashedPassword = try? Bcrypt.hash(userReq.password) else {
            throw Abort(.internalServerError)
        }
        let user = User(id: UUID(), userId: UUID(), login: userReq.login, password: hashedPassword)
        return user.save(on: req.db).map { user }
    }
    
    app.delete("delete") { req -> EventLoopFuture<HTTPStatus> in
        let userId = try req.parameters.require("userId", as: UUID.self)

        return User.query(on: req.db)
            .filter(\User.$userId == userId)
            .delete()
            .transform(to: .noContent)
    }


    app.post("login") { req -> EventLoopFuture<LoginResponse> in
        let userReq = try req.content.decode(UserReq.self)

        return User.query(on: req.db)
            .filter(\.$login == userReq.login)
            .first()
            .flatMapThrowing { user -> LoginResponse in
                guard let user = user else {
                    throw Abort(.unauthorized)
                }
                if try Bcrypt.verify(userReq.password, created: user.password) {
                    let userToken = User.Payload(userId: user.userId)
                    let jwt = try req.jwt.sign(userToken) as String
                    return LoginResponse(userid: user.userId.uuidString, jwt: jwt)
                } else {
                    throw Abort(.unauthorized)
                }
            }
    }
    
    
    auth.get("users") { req in
        // Verify the JWT token and extract the payload
        let userPayload = try req.auth.require(User.Payload.self)

        // You can now use the payload information for authorization logic

        return User.query(on: req.db)
            .all()
            .map { users in
                return users
            }
            .flatMapErrorThrowing { error in
                throw Abort(.unauthorized, reason: "Invalid token or unauthorized access")
            }
    }

    
//    app.get("users") { req async throws in
//        
//        try await User.query(on: req.db).all()
//    }
}

