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
open class MQOperation : Operation, MQExecutableTask {
    
    open var type: MQExecutableTaskType {
        return .nsOperation
    }
    
    /**
    Tasks that need execution before the main `process()` function is executed.
    An example of what to do in a `startBlock` would be to show a loading view.
    */
    open var startBlock: (() -> Void)?
    
    open var returnBlock: (() -> Void)?
    
    /**
    Executed after the `preparationBlock` if `error` is `nil`.
    You must take care of dispatching UI-related tasks in the `successBlock` to the
    main thread.
    */
    open var successBlock: ((Any?) -> Void)?
    
    /**
    Executed after the `preparationBlock` if the `error` is non-`nil`.
    You must take care of dispatching UI-related tasks in the `failureBlock` to the
    main thread.
    */
    open var failureBlock: ((NSError) -> Void)?
    
    open var finishBlock: (() -> Void)?
    
    /**
    The error that was produced during the process block. If this property is `nil`,
    the operation is considered successful and the `successBlock` is executed.
    Otherwise, the `failureBlock` is executed.
    */
    open var error: NSError?
    
    /**
    The value that will be returned to the `successBlock` when it is executed.
    */
    open var result: Any?
    
    open override func main() {
        if self.isCancelled {
            return
        }
        
        self.runStartBlock()
        
        if self.isCancelled {
            return
        }
        
        self.mainProcess()
        
        if self.isCancelled {
            return
        }
        
        self.runReturnBlock()
        
        if self.isCancelled {
            return
        }
        
        if let error = self.error {
            self.runFailureBlockAndFinish(error: error)
        } else {
            self.runSuccessBlockAndFinish(result: self.result)
        }
    }
    
    /**
    Defines the main process of this operation. Assign a value to the `error`
    property to mark the operation as failed.
    
    You must constantly check for the operation's `cancelled` property when
    overriding this method.
    */
    open func mainProcess() {
        
    }
    
    /**
    Only here to comply with MQExecutableTaskProtocol.
    */
    public final func begin() {
        
    }
    
    open func runStartBlock() {
        MQExecutableTaskBlockRunner.runStartBlockOfTask(self)
    }
    
    open func runReturnBlock() {
        MQExecutableTaskBlockRunner.runReturnBlockOfTask(self)
    }
    
    open func runSuccessBlockAndFinish(result: Any?) {
        MQExecutableTaskBlockRunner.runSuccessBlockOfTaskAndFinish(self, withResult: result)
    }
    
    open func runFailureBlockAndFinish(error: NSError) {
        MQExecutableTaskBlockRunner.runFailureBlockOfTaskAndFinish(self, withError: error)
    }
    
    open func runFinishBlock() {
        MQExecutableTaskBlockRunner.runFinishBlockOfTask(self)
    }
    
    open func overrideFailureBlockToShowErrorDialogInPresenter(_ presenter: UIViewController) {
        MQExecutableTaskBlockRunner.overrideFailureBlockOfTask(self,
            toShowErrorDialogInPresenter: presenter)
    }
    
}
