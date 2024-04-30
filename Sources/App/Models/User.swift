//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor
import JWT

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "login")
    var login: String
    
    @Field(key: "password")
    var password: String

    init() { }

    init(id: UUID? = UUID(), userId: UUID, login: String, password: String) {
        self.id = id
        self.userId = userId
        self.login = login
        self.password = password
    }
}

extension User {
    func toPublic() -> User.Public {
        return User.Public(id: self.id!, login: self.login)
    }
    
    struct Public: Content {
        var id: UUID
        var login: String
    }
    
    struct Payload: JWTPayload {
        var userId: UUID
        
        func verify(using signer: JWTSigner) throws {
        }
    }
}

extension User: Authenticatable {
}


final class UserReq: Content {
    var login: String    
    var password: String

    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
