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
import Fluent

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
    
    struct Payload: JWTPayload, Authenticatable {
        var userId: UUID
        
        func verify(using signer: JWTSigner) throws {
        }
    }
}

//extension User: Authenticatable {
//}

extension User: ModelAuthenticatable {
    
    static let usernameKey = \User.$login
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        return password == self.password
    }
}


final class UserReq: Content {
    var login: String    
    var password: String

    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

final class LoginResponse: Content {
    var jwt: String
    var userid: String
    init(userid: String, jwt: String) {
        self.userid = userid
        self.jwt = jwt
    }
}
