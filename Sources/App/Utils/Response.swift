//
//  File.swift
//  
//
//  Created by smgoncharov on 30.04.2024.
//

import Foundation
import Vapor

final class Response: Content {
    
    var successData: SuccessData?
    var failureData: FailureData?
    
    final class SuccessData: Content {}
    
    final class FailureData: Content {}
}
