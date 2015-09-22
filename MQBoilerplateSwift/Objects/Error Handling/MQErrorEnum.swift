//
//  MQErrorEnum.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/24/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public protocol MQErrorEnum: ErrorType {
    
    func errorObject() -> MQError
    
}