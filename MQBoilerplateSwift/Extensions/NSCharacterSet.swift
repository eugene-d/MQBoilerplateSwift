//
//  NSCharacterSet.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension CharacterSet {
    
    public static func decimalNumberCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789.")
    }
    
}
