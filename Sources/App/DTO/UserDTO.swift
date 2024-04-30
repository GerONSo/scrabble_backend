//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var name: String
}
