//
//  MQUnexpectedError.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/30/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQUnexpectedError: MQError {
    
    public init(_ message: String) {
        super.init("An unexpected error occurred:\n\(message)", code: .Unexpected)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}