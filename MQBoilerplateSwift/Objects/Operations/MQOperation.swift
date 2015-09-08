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
    // FIXME: Swift 2.0
//    public var failureBlock: ((ErrorType) -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    
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
        // FIXME: Swift 2.0
//        defer {
//            if self.cancelled == false {
//                self.runFinishBlock()
//            }
//        }
        
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
        
        // FIXME: Swift 2.0
//        do {
//            let result = try buildResult(nil)
//            self.runSuccessBlockWithResult(result)
//        } catch {
//            self.runFailureBlockWithError(error)
//        }
        
        if let (result, error) = self.buildResult(nil) {
            if let error = error {
                self.runFailureBlockWithError(error)
            } else {
                self.runSuccessBlockWithResult(result)
            }
        } else {
            self.runSuccessBlockWithResult(nil)
        }
        
        if self.cancelled == false {
            self.runFinishBlock()
        }
    }
    
    /**
    Override point for converting raw results (usually a JSON object) into your own custom object or value type.
    The returned value is a tuple. If `error` is non-nil, the build process failed (e.g. invalid JSON) and `result`
    **must** be nil. If `error` is nil, then the build process succeeded and `result` may or may not have a value
    depending on whether it matters or not. For simplicity, you can simply return `nil` if you wish to return `(nil, nil).
    */
    // FIXME: Swift 2.0: Use the signature
    // public func buildResult(rawResult: Any?) throws -> Any?
    public func buildResult(rawResult: Any?) -> (result: Any?, error: NSError?)? {
        return (nil, nil)
    }
    
    /**
    Performs the `startBlock` in the main UI thread and waits until it is finished.
    */
    public func runStartBlock() {
        // FIXME: Swift 2.0
        if let startBlock = self.startBlock {
            if self.cancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(startBlock)
        }
    }
    
    /**
    Performs the `returnBlock` in the main UI thread and waits until it is finished.
    */
    public func runReturnBlock() {
        // FIXME: Swift 2.0
        if let returnBlock = self.returnBlock {
            if self.cancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(returnBlock)
        }
    }
    
    /**
    Performs the `successBlock` in the main UI thread and waits until it is finished.
    */
    public func runSuccessBlockWithResult(result: Any?) {
        // FIXME: Swift 2.0
//        guard let successBlock = self.successBlock else {
//            return
//        }
//        
//        if self.cancelled {
//            return
//        }
//        
//        MQDispatcher.syncRunInMainThread {
//            successBlock(result)
//        }
        
        if let successBlock = self.successBlock {
            if self.cancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread {
                successBlock(result)
            }
        }
    }
    
    /**
    Performs the `failureBlock` in the main UI thread and waits until it is finished.
    */
    // FIXME: Swift 2.0
//    public func runFailureBlockWithError(error: ErrorType) {
    public func runFailureBlockWithError(error: NSError) {
        // FIXME: Swift 2.0
//        guard let failureBlock = self.failureBlock else {
//            return
//        }
//        
//        if self.cancelled {
//            return
//        }
//        
//        MQDispatcher.syncRunInMainThread {
//            failureBlock(error)
//        }
        
        if let failureBlock = self.failureBlock {
            if self.cancelled {
                return
            }
            MQDispatcher.syncRunInMainThread {
                failureBlock(error)
            }
        }
    }
    
    /**
    Performs the `finishBlock` in the main UI thread and waits until it is finished.
    */
    public func runFinishBlock() {
        // FIXME: Swift 2.0
//        guard let finishBlock = self.finishBlock else {
//            return
//        }
//        
//        if self.cancelled {
//            return
//        }
//        
//        MQDispatcher.syncRunInMainThread(finishBlock)
        
        if let finishBlock = self.finishBlock {
            if self.cancelled {
                return
            }
            
            MQDispatcher.syncRunInMainThread(finishBlock)
        }
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