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
    
    public init() {}
    
    public func begin() {
        self.performStart()
        self.mainProcess()
    }
    
    public func mainProcess() {
        
    }
    
    public func performStart() {
        if let startBlock = self.startBlock {
            MQDispatcher.syncRunInMainThread {[unowned self] in
                startBlock()
            }
        }
    }
    
    public func performReturn() {
        if let returnBlock = self.returnBlock {
            MQDispatcher.syncRunInMainThread {[unowned self] in
                returnBlock()
            }
        }
    }
    
    public func performSuccessWithResult(result: Any?) {
        if let successBlock = self.successBlock {
            MQDispatcher.syncRunInMainThread {[unowned self] in
                successBlock(result)
                self.runFinishBlock()
            }
        }
    }
    
    public func performFailureWithError(error: NSError) {
        if let failureBlock = self.failureBlock {
            MQDispatcher.syncRunInMainThread {[unowned self] in
                failureBlock(error)
                self.runFinishBlock()
            }
        }
    }
    
    public func runFinishBlock() {
        if let finishBlock = self.finishBlock {
            MQDispatcher.syncRunInMainThread(finishBlock)
        }
    }
    
}