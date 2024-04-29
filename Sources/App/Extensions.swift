//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation


extension String {
    func toUUID() -> UUID? {
        UUID.init(uuidString: self)
    }
}
