//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class DefaultResponse: Content {
    var success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}
