//
//  MQChainedTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQChainedTask: MQExecutableTask {
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    
    /**
    You typically don't define a failureBlock for a `MQChainedTask` because
    the `failureBlock`s of its individual tasks should be executed.
    */
    public var failureBlock: ((NSError) -> Void)?
    
    /**
    The block that is executed in the main thread when the chain successfully executes until the last task.
    */
    public var successBlock: ((Any?) -> Void)?
    
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    lazy var operationQueue = NSOperationQueue()
    var tasks = [MQExecutableTask]()
    
    public init(_ tasks: MQExecutableTask ...) {
        for task in tasks {
            self.tasks.append(task)
        }
    }
    
    public func execute() {
        MQDispatcher.asyncRunInBackgroundThread {[unowned self] in
            self.buildChain()
            self.performSequence()
        }
    }
    
    public func performSequence() {
        self.runStartBlock()
        if let firstTask = self.tasks.first {
            firstTask.execute()
        }
    }
    
    func buildChain() {
        for i in 0 ..< self.tasks.count {
            let currentTask = self.tasks[i]
            
            // Ignore the task's start, return, and finish blocks because
            // the chained tasks' similar callback blocks will be used instead.
            currentTask.startBlock = nil
            currentTask.returnBlock = nil
            currentTask.finishBlock = nil
            
            let someCustomSuccessBlock = currentTask.successBlock
            currentTask.successBlock = {[unowned self] result in
                // Run the task's successBlock first.
                if let customSuccessBlock = someCustomSuccessBlock {
                    MQDispatcher.syncRunInMainThread {
                        customSuccessBlock(result)
                    }
                }
                
                if i + 1 < self.tasks.count {
                    // If there is a next task, override the success block to chain to it.
                    let nextTask = self.tasks[i + 1]
                    nextTask.execute()
                } else {
                    // Otherwise, this is the last task in the chain and the chain's
                    // successBlock should be executed.
                    self.runReturnBlock()
                    self.runSuccessBlockWithResult(result)
                    self.runFinishBlock()
                }
            }
            
            let someCustomFailureBlock = currentTask.failureBlock
            currentTask.failureBlock = {[unowned self] error in
                // The returnBlock should be executed by each task.
                self.runReturnBlock()
                
                // Run the task's failureBlock.
                if let customFailureBlock = someCustomFailureBlock {
                    MQDispatcher.syncRunInMainThread {
                        customFailureBlock(error)
                    }
                }
                
                // Run the chained task's failureBlock.
                self.runFailureBlockWithError(error)
                
                // RUn the chained task's finishBlock.
                self.runFinishBlock()
            }
        }
    }
    
    public func computeResult() {
        // Meaningless to this class, leave empty.
    }
    
}