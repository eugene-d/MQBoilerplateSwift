//
//  MQTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 01/02/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

public class MQTask: NSOperation {
    
    public var startBlock: (Void -> Void)?
    public var returnBlock: (Void -> Void)?
    public var successBlock: (Any? -> Void)?
    public var failBlock: (NSError -> Void)?
    public var finishBlock: (Void -> Void)?
    
    // MARK: Internal state variables
    
    private var _executing = false
    private var _finished = false
    
    // MARK: NSOperation required overrides
    
    public override var concurrent: Bool {
        return true
    }
    
    public override var asynchronous: Bool {
        return true
    }
    
    public override var executing: Bool {
        return self._executing
    }
    
    public override var finished: Bool {
        return self._finished
    }
    
    // MARK: Builders
    
    public func onStart(startBlock: Void -> Void) -> MQTask {
        self.startBlock = startBlock
        return self
    }
    
    public func onReturn(returnBlock: Void -> Void) -> MQTask {
        self.returnBlock = returnBlock
        return self
    }
    
    public func onSuccess(successBlock: Any? -> Void) -> MQTask {
        self.successBlock = successBlock
        return self
    }
    
    public func onFail(failBlock: NSError -> Void) -> MQTask {
        self.failBlock = failBlock
        return self
    }
    
    public func onFinish(finishBlock: Void -> Void) -> MQTask {
        self.finishBlock = finishBlock
        return self
    }
    
    public func buildResult(object: Any?) throws -> Any? {
        return nil
    }
    
    // MARK: Functions
    
    public override func start() {
        if self.cancelled {
            self.willChangeValueForKey("isFinished")
            self._finished = true
            self.didChangeValueForKey("isFinished")
            return
        }
        
        self.willChangeValueForKey("isExecuting")
        NSThread.detachNewThreadSelector(Selector("main"), toTarget: self, withObject: nil)
        self._executing = true
        self.didChangeValueForKey("isExecuting")
    }
    
    public override func main() {
        defer {
            if self.cancelled == false {
                if let finishBlock = self.finishBlock {
                    finishBlock()
                }
            }
            self.closeOperation()
        }
        
        if let startBlock = self.startBlock {
            startBlock()
        }
        
        do {
            let result = try self.buildResult(nil)
            
            if let returnBlock = self.returnBlock {
                returnBlock()
            }
            
            if let successBlock = self.successBlock {
                successBlock(result)
            }
        } catch {
            if let returnBlock = self.returnBlock {
                returnBlock()
            }
            
            if let failBlock = self.failBlock {
                failBlock(error)
            }
        }
    }
    
    public func closeOperation() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        self._executing = false
        self._finished = true
        
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
    
}