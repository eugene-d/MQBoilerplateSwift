//
//  MQInputField.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQInputField {
    
    public var name: String
    public var value: AnyObject?
    
    public init(name: String) {
        self.name = name
    }
    
    public convenience init(name: String, value: AnyObject?) {
        self.init(name: name)
        self.value = value
    }
    
}