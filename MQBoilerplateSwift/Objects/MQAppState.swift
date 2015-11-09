//
//  MQAppState.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 09/11/2015.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

private let _instance = MQAppState()

public class MQAppState {
    
    public class var sharedInstance: MQAppState {
        return _instance
    }
    
    private init() {}
    
    public func save() throws {
        
    }
    
    public func restore() {
        
    }
    
    public func clearAll() {
        
    }
    
}