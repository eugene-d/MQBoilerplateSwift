//
//  MQExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/5/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public protocol MQExecutableTask: class {
    
    var startBlock: (() -> Void)? { get set }
    var returnBlock: (() -> Void)? { get set }
    var successBlock: ((Any?) -> Void)? { get set }
    var failureBlock: ((NSError) -> Void)? { get set }
    var finishBlock: (() -> Void)? { get set }
    
    var result: Any? { get set }
    var error: NSError? { get set }
    
//    init(startBlock: (() -> Void)?,
//        returnBlock: (() -> Void)?,
//        successBlock: ((Any?) -> Void)?,
//        failureBlock: ((NSError) -> Void)?,
//        finishBlock: (() -> Void)?)
    
    func execute()
    func performSequence()
    func computeResult()
    
    /**
    Implemented by subclasses to synchronously perform the `startBlock` in the main thread
    and waits for it to return before proceeding.
    */
    func runStartBlock()
    
    /**
    Implemented by subclasses to synchronously perform the `returnBlock` in the main thread
    and waits for it to return before proceeding.
    */
    func runReturnBlock()
    
    func runSuccessBlockWithResult(result: Any?)
    
    func runFailureBlockWithError(error: NSError)
    
    func runFinishBlock()
    
    func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController)
    
}

/**
This extension of `MQExecutableTask` is here to provide default implementations
to any object that complies with the `MQExecutableTask` protocol.
*/
public extension MQExecutableTask {
    
    public func runStartBlock() {
        guard let startBlock = self.startBlock else {
            return
        }
        
        // If the task is an operation, check first if it has been cancelled.
        if let operation = self as? MQOperation {
            if operation.cancelled {
                return
            }
        }
        
        MQDispatcher.syncRunInMainThread(startBlock)
    }
    
    public func runReturnBlock() {
        guard let returnBlock = self.returnBlock else {
            return
        }
        
        // If the task is an operation, check first if it has been cancelled.
        if let operation = self as? MQOperation {
            if operation.cancelled {
                return
            }
        }
        
        MQDispatcher.syncRunInMainThread(returnBlock)
    }
    
    public func runSuccessBlockWithResult(result: Any?) {
        guard let successBlock = self.successBlock else {
            return
        }
        
        // If the task is an operation, check first if it has been cancelled.
        if let operation = self as? MQOperation {
            if operation.cancelled {
                return
            }
        }
        
        MQDispatcher.syncRunInMainThread {
            successBlock(result)
        }
    }
    
    public func runFailureBlockWithError(error: NSError) {
        guard let failureBlock = self.failureBlock else {
            return
        }
        // If the task is an operation, check first if it has been cancelled.
        if let operation = self as? MQOperation {
            if operation.cancelled {
                return
            }
        }
        
        MQDispatcher.syncRunInMainThread {
            failureBlock(error)
        }
    }
    
    public func runFinishBlock() {
        guard let finishBlock = self.finishBlock else {
            return
        }
        
        // If the task is an operation, check first if it has been cancelled.
        if let operation = self as? MQOperation {
            if operation.cancelled {
                return
            }
        }
        
        MQDispatcher.syncRunInMainThread(finishBlock)
    }
    
    public func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController) {
        let someCustomFailureBlock = self.failureBlock
        self.failureBlock = {error in
            if let operation = self as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            
            if let operation = self as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
}