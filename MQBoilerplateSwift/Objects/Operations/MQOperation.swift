//
//  MQOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
An `MQOperation` is any task that needs to execute code at various points during its execution
and depending on whether it succeeds or fails. This is a subclass of `NSOperation` and must be
added to an `NSOperationQueue` to execute. For an asynchronous implementation, see `MQAsynchronousOperation`.
*/
public class MQOperation: NSOperation {
    
    /**
    Executed when the operation begins. For example, you can show a loading screen in this block.
    */
    public var startBlock: (() -> Void)?
    
    /**
    Executed when the operation finishes processing but before a success or failure status is determined.
    */
    public var returnBlock: (() -> Void)?
    
    /**
    Executed when the operation produces an error, e.g., show an error dialog.
    */
    public var failureBlock: ((ErrorType) -> Void)?
    
    /**
    Executed when the operation produces a result, e.g., showing a `UITableView` of results.
    */
    public var successBlock: ((Any?) -> Void)?
    
    /**
    Executed before the operation closes regardless of whether it succeeds or fails, e.g., closing I/O streams.
    */
    public var finishBlock: (() -> Void)?
    
    /**
    Defines the operation and at which points the callback blocks are executed.
    */
    public override func main() {
        defer {
            if self.cancelled == false {
                self.runFinishBlock()
            }
        }
        
        if self.cancelled {
            return
        }
        
        self.runStartBlock()
        
        if self.cancelled {
            return
        }
        
        self.runReturnBlock()
        
        if self.cancelled {
            return
        }
        
        do {
            let result = try buildResult(nil)
            self.runSuccessBlockWithResult(result)
        } catch {
            self.runFailureBlockWithError(error)
        }
    }
    
    /**
    Override point for converting raw results (usually in JSON format) to your
    custom object or value types. Make sure to check for `self.cancelled` from inside the function.
    */
    public func buildResult(rawResult: Any?) throws -> Any? {
        return nil
    }
    
    /**
    Performs the `startBlock` in the main UI thread and waits until it is finished.
    */
    public func runStartBlock() {
        guard let startBlock = self.startBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(startBlock)
    }
    
    /**
    Performs the `returnBlock` in the main UI thread and waits until it is finished.
    */
    public func runReturnBlock() {
        guard let returnBlock = self.returnBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(returnBlock)
    }
    
    /**
    Performs the `successBlock` in the main UI thread and waits until it is finished.
    */
    public func runSuccessBlockWithResult(result: Any?) {
        guard let successBlock = self.successBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread {
            successBlock(result)
        }
    }
    
    /**
    Performs the `failureBlock` in the main UI thread and waits until it is finished.
    */
    public func runFailureBlockWithError(error: ErrorType) {
        guard let failureBlock = self.failureBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread {
            failureBlock(error)
        }
    }
    
    /**
    Performs the `finishBlock` in the main UI thread and waits until it is finished.
    */
    public func runFinishBlock() {
        guard let finishBlock = self.finishBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(finishBlock)
    }
    
    /**
    Overrides the current `failureBlock` to show an error dialog in a provided `UIViewController`.
    */
    public func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController) {
        self.failureBlock = {[unowned presenter] error in
            if self.cancelled {
                return
            }
            
            MQErrorDialog.showError(error, inPresenter: presenter)
        }
    }
    
}