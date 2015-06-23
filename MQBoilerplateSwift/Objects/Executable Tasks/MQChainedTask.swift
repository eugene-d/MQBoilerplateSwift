//
//  MQChainedTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQChainedTask: MQExecutableTask {
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    public func execute() {
        
    }
    
    public func performSequence() {
        
    }
    
    public func computeResult() {
        
    }
    
}