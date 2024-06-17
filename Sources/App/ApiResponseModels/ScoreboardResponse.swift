//
//  File.swift
//  
//
//  Created by smgoncharov on 17.06.2024.
//

import Foundation
import Vapor

final class ScoreboardResponse: Content {
    
    var scoreboard: [ScoreboardDTO]
    
    init(scoreboard: [ScoreboardDTO]) {
        self.scoreboard = scoreboard
    }
    
    enum CodingKeys: String, CodingKey {
        case scoreboard
    }
}
