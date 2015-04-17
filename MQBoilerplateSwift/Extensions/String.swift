//
//  String.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension String {
    
    public func hasCharactersFromSet(characterSet: NSCharacterSet) -> Bool {
        if let range = self.rangeOfCharacterFromSet(characterSet) {
            return true
        }
        return false
    }
    
}