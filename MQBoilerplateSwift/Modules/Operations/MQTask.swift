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
    
    public var executeCallbacksInMainThread = true
    
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
            self.closeOperation()
        }
        
        self.runStartBlock()
        
        if self.cancelled {
            return
        }
        
        do {
            let result = try self.buildResult(nil)
            
            if self.cancelled {
                return
            }
            
            self.runReturnBlock()
            
            if self.cancelled {
                return
            }
            
            self.runSuccessBlock(result)
        } catch {
            self.runReturnBlock()
            
            if self.cancelled {
                return
            }
            
            self.runFailBlock(error)
        }
    }
    
    public func closeOperation() {
        if self.cancelled == false {
            self.runFinishBlock()
        }
        
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        self._executing = false
        self._finished = true
        
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
    
    public func runStartBlock() {
        print("\(__FUNCTION__)")
        guard let startBlock = self.startBlock
            else {
                return
        }
        
        if self.executeCallbacksInMainThread == true {
            MQDispatcher.syncRunInMainThread(startBlock)
        } else {
            startBlock()
        }
    }
    
    public func runReturnBlock() {
        print("\(__FUNCTION__)")
        guard let returnBlock = self.returnBlock
            else {
                return
        }
        
        if self.executeCallbacksInMainThread == true {
            MQDispatcher.syncRunInMainThread(returnBlock)
        } else {
            returnBlock()
        }
    }
    
    public func runSuccessBlock(result: Any?) {
        print("\(__FUNCTION__)")
        guard let successBlock = self.successBlock
            else {
                return
        }
        
        if self.executeCallbacksInMainThread == true {
            MQDispatcher.syncRunInMainThread {
                successBlock(result)
            }
        } else {
            successBlock(result)
        }
    }
    
    public func runFailBlock(error: NSError) {
        print("\(__FUNCTION__)")
        guard let failBlock = self.failBlock
            else {
                return
        }
        
        if self.executeCallbacksInMainThread == true {
            MQDispatcher.syncRunInMainThread {
                failBlock(error)
            }
        } else {
            failBlock(error)
        }
    }
    
    public func runFailBlock(error: ErrorType) {
        print("\(__FUNCTION__)")
        if let error = error as? MQErrorType {
            self.runFailBlock(error.object())
        } else {
            self.runFailBlock(error as NSError)
        }
    }
    
    public func runFinishBlock() {
        print("\(__FUNCTION__)")
        guard let finishBlock = self.finishBlock
            else {
                return
        }
        
        if self.executeCallbacksInMainThread == true {
            MQDispatcher.syncRunInMainThread(finishBlock)
        } else {
            finishBlock()
        }
    }
    
}