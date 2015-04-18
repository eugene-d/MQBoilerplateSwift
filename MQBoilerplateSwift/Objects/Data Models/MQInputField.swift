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
    public var value: Any?
    
    public init(name: String) {
        self.name = name
    }
    
    public convenience init(name: String, value: Any?) {
        self.init(name: name)
        self.value = value
    }
    
}