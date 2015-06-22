//
//  MQExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/5/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public enum MQExecutableTaskType {
    case Default, NSOperation
}

public protocol MQExecutableTaskBaseProtocol: class {
    
    var type: MQExecutableTaskType { get }
    
    var startBlock: (() -> Void)? { get set }
    var returnBlock: (() -> Void)? { get set }
    var failureBlock: ((NSError) -> Void)? { get set }
    var successBlock: ((Any?) -> Void)? { get set }
    var finishBlock: (() -> Void)? { get set }
    
    var result: Any? { get set }
    var error: NSError? { get set }
    
    func execute()
    func performSequence()
    func computeResult()
    
    /**
    Implemented by subclasses to synchronously perform the `startBlock` in the main thread
    if it exists, and waits for it to return before proceeding.
    */
    func runStartBlock()
    
    /**
    Implemented by subclasses to synchronously perform the `returnBlock` in the main thread
    if it exists, and waits for it to return before proceeding.
    */
    func runReturnBlock()
    
    /*/**
    Implemented by subclasses to synchronously perform the `successBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    @available(*, deprecated=1.11, message="Use runSuccessBlockWithResult() instead. The finish block should be executed in a defer block.")
    func runSuccessBlockAndFinish(result result: Any?)*/
    
    /*/**
    Implemented by subclasses to synchronously perform the `failureBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    @available(*, deprecated=1.11, message="Use runFailureBlockWithError() instead. The finish block should be executed in a defer block.")
    func runFailureBlockAndFinish(error error: NSError)*/
    
    func runSuccessBlockWithResult(result: Any?)
    
    func runFailureBlockWithError(error: NSError)
    
    func runFinishBlock()
    
    func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController)
    
}

public protocol MQExecutableTask: MQExecutableTaskBaseProtocol {
    
}

/**
This extension of `MQExecutableTask` is here to provide default implementations
to any object that complies with the `MQExecutableTask` protocol.
*/
public extension MQExecutableTask {
    
//    public func execute() {
//        
//    }
//    
//    public func performSequence() {
//        
//    }
//    
//    public func computeResult() {
//        
//    }
    
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