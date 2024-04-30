//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation


extension String {
    func toUUID() -> UUID? {
        return UUID.init(uuidString: self)
    }
}
