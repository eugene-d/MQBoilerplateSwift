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
public class MQOperation : NSOperation {
    
    /**
    Tasks that need execution before the main `process()` function is executed.
    An example of what to do in a `startBlock` would be to show a loading view.
    */
    public var startBlock: (Void -> Void)?
    
    /**
    Tasks that need to be executed after the process block finishes, but before
    either the success of failure block is executed. An example of what to do in
    a `finishBlock` is to hide a screen's "Loading" view before either showing
    the results or an error message.
    */
    public var finishBlock: (Void -> Void)?
    
    /**
    Executed after the `preparationBlock` if `error` is `nil`.
    You must take care of dispatching UI-related tasks in the `successBlock` to the
    main thread.
    */
    public var successBlock: ((AnyObject?) -> Void)?
    
    /**
    Executed after the `preparationBlock` if the `error` is non-`nil`.
    You must take care of dispatching UI-related tasks in the `failureBlock` to the
    main thread.
    */
    public var failureBlock: ((NSError) -> Void)?
    
    /**
    The error that was produced during the process block. If this property is `nil`,
    the operation is considered successful and the `successBlock` is executed.
    Otherwise, the `failureBlock` is executed.
    */
    public var error: NSError?
    
    /**
    The value that will be returned to the `successBlock` when it is executed.
    */
    public var result: AnyObject?
    
    public override func main() {
        if self.cancelled {
            return
        }
        
        if let startBlock = self.startBlock {
            startBlock()
        }
        
        if self.cancelled {
            return
        }
        
        self.process()
        
        if self.cancelled {
            return
        }
        
        self.finish()
        
        if self.cancelled {
            return
        }
        
        if let error = self.error {
            self.failWithError(error)
        } else {
            self.succeedWithResult(self.result)
        }
    }
    
    /**
    Defines the main process of this operation. Assign a value to the `error`
    property to mark the operation as failed.
    
    You must constantly check for the operation's `cancelled` property when
    overriding this method.
    */
    public func process() {
        
    }
    
    public func finish() {
        if let finishBlock = self.finishBlock {
            MQDispatcher.executeInMainThread(finishBlock)
        }
    }
    
    public func failWithError(error: NSError) {
        if let failureBlock = self.failureBlock {
            MQDispatcher.executeInMainThread {
                failureBlock(error)
            }
        }
    }
    
    public func succeedWithResult(result: AnyObject?) {
        if let successBlock = self.successBlock {
            MQDispatcher.executeInMainThread {
                successBlock(self.result)
            }
        }
    }
    
    public func showErrorDialogOnFail(#presenter: UIViewController) {
        let someCustomFailureBlock = self.failureBlock
        self.failureBlock = {[unowned self] error in
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
}