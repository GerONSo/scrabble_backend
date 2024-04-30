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
    
    func removeLetters(letters: String) -> String {
        var newString = self
        for l in letters {
            guard let index = newString.firstIndex(of: l) else {
                continue
            }
            newString.remove(at: index)
        }
        return newString
    }
    
    func getRandomLetters(n: Int) -> String {
        return String(self.shuffled().prefix(n))
    }
}
