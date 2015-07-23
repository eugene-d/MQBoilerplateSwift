//
//  MQOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/23/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
An `MQOperation` is defined as a synchronous operation and should only be executed
by adding it to an `NSOperationQueue`.

See *Asynchronous Versus Synchronous Operations* in:
https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/index.html
*/
public class _MQOperation : NSOperation, MQExecutableTask {
    
    /**
    Tasks that need execution before the main `process()` function is executed.
    An example of what to do in a `startBlock` would be to show a loading view.
    */
    public var startBlock: (() -> Void)?
    
    public var returnBlock: (() -> Void)?
    
    /**
    Executed after the `preparationBlock` if `error` is `nil`.
    You must take care of dispatching UI-related tasks in the `successBlock` to the
    main thread.
    */
    public var successBlock: ((Any?) -> Void)?
    
    /**
    Executed after the `preparationBlock` if the `error` is non-`nil`.
    You must take care of dispatching UI-related tasks in the `failureBlock` to the
    main thread.
    */
    public var failureBlock: ((NSError) -> Void)?
    
    public var finishBlock: (() -> Void)?
    
    /**
    The error that was produced during the process block. If this property is `nil`,
    the operation is considered successful and the `successBlock` is executed.
    Otherwise, the `failureBlock` is executed.
    */
    public var error: NSError?
    
    /**
    The value that will be returned to the `successBlock` when it is executed.
    */
    public var result: Any?
    
    public override func main() {
        self.performSequence()
    }
    
    public func execute() {
        // Empty function. This means nothing for an MQOperation since they are triggered
        // by being added to an instance of NSOperationQueue.
        // This function is simply here for protocol compliance.
    }
    
    public func performSequence() {
        defer {
            self.runFinishBlock()
        }
        
        if self.cancelled {
            return
        }
        
        self.runStartBlock()
        
        if self.cancelled {
            return
        }
        
        self.computeResult()
        
        if self.cancelled {
            return
        }
        
        self.runReturnBlock()
        
        if self.cancelled {
            return
        }
        
        if let error = self.error {
            self.runFailureBlockWithError(error)
        } else {
            self.runSuccessBlockWithResult(result)
        }
    }
    
    public func computeResult() {
        
    }
    
}