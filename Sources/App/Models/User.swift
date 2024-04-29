//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: String
    
    @Field(key: "login")
    var login: String
    
    @Field(key: "password")
    var password: String

    init() { }

    init(id: UUID? = nil, userId: String, login: String, password: String) {
        self.id = id
        self.userId = userId
        self.login = login
        self.password = password
    }
}

