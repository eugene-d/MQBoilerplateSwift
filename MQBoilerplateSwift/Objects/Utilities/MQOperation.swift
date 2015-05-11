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
public class MQOperation : NSOperation, MQExecutableTask {
    
    public var type: MQExecutableTaskType {
        return .NSOperation
    }
    
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
        if self.cancelled {
            return
        }
        
        self.performStart()
        
        if self.cancelled {
            return
        }
        
        self.process()
        
        if self.cancelled {
            return
        }
        
        self.performReturn()
        
        if self.cancelled {
            return
        }
        
        if let error = self.error {
            self.performFailureWithError(error)
        } else {
            self.performSuccessWithResult(self.result)
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
    
    public func showErrorDialogOnFail(#presenter: UIViewController) {
        let someCustomFailureBlock = self.failureBlock
        self.failureBlock = {[unowned self] error in
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
    public func performStart() {
        if let startBlock = self.startBlock {
            MQDispatcher.syncRunInMainThread {
                if self.cancelled {
                    return
                }
                startBlock()
            }
        }
    }
    
    public func performReturn() {
        if let returnBlock = self.returnBlock {
            MQDispatcher.syncRunInMainThread {
                if self.cancelled {
                    return
                }
                returnBlock()
            }
        }
    }
    
    public func performSuccessWithResult(result: Any?) {
        if let successBlock = self.successBlock {
            MQDispatcher.syncRunInMainThread {
                if self.cancelled {
                    return
                }
                successBlock(result)
                
                if let finishBlock = self.finishBlock {
                    if self.cancelled {
                        return
                    }
                    finishBlock()
                }
            }
        }
    }
    
    public func performFailureWithError(error: NSError) {
        if let failureBlock = self.failureBlock {
            MQDispatcher.syncRunInMainThread {
                if self.cancelled {
                    return
                }
                failureBlock(error)
                
                if let finishBlock = self.finishBlock {
                    if self.cancelled {
                        return
                    }
                    finishBlock()
                }
            }
        }
    }
    
}