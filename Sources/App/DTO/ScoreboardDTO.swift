//
//  File.swift
//  
//
//  Created by smgoncharov on 17.06.2024.
//

import Foundation
import Vapor

struct ScoreboardDTO: Content {
    
    var name: String
    var score: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case score
    }
}
