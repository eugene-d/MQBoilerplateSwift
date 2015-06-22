//
//  MQConcreteExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/26/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQConcreteExecutableTask: MQExecutableTask {
    
    public var type: MQExecutableTaskType {
        return .Default
    }
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    public init() {}
    
    public func begin() {
        self.performCallbacks()
    }
    
    public func performCallbacks() {
        defer {
            self.runFinishBlock()
        }
        
        self.runStartBlock()
        
        self.computeResult()
        
        self.runReturnBlock()

        if let error = self.error {
            self.runFailureBlockWithError(error)
        } else {
            self.runSuccessBlockWithResult(self.result)
        }
    }
    
}