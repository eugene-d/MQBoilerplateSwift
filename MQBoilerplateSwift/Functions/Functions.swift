//
//  Functions.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/22/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public func nonEmptyString(arg: Any?) -> String? {
    if let string = arg as? String {
        if string.isEmpty == false {
            return string
        }
    }
    return nil
}