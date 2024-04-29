//
//  File.swift
//  
//
//  Created by smgoncharov on 29.04.2024.
//

import Foundation

class InviteCodeGenerator {
    static func generate() -> String {
        return randomString(length: 5)
    }
    
    private static func randomString(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
