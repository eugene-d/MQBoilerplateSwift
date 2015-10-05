//
//  ErrorType.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 9/29/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension ErrorType {
    
    /**
    Represents the conforming entity as an `NSError` object. Remember that `NSError` objects thrown from a
    `do` block take the form of `ErrorType` and casting them to `NSError` inside a `catch` **overrides** the
    error's properties. In custom `NSError` subclasses, you can override this function to return `self`, so
    that you can call this function to obtain an `NSError` object whose properties are retained.
    
    This function is also useful for simply throwing around cases of `ErrorType` enums and getting an
    `NSError` object representation of the case.
    */
    func toObject() -> NSError {
        return self as NSError
    }
    
}