//
//  MQChainedOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
Executes a chain of `MQOperation`s if all of them succeed; otherwise,
automatically handles failure if any of the operations in the chain fail.

Setting the callback blocks of an `MQChainedOperation` overrides the callback
blocks of all operations in the chain **except for the `successBlock`**, because operations
often have their own logic for handling results.
*/
public class MQChainedOperation: MQAsynchronousOperation {
    
    var operationQueue = NSOperationQueue()
    var operations: [MQOperation]
    
    /**
    Returns `nil` and cannot be assigned a value. Each operation in the chain
    has a `successBlock` of its own.
    */
    public override var successBlock: ((Any?) -> Void)? {
        get {
            return nil
        }
        set { }
    }
    
    public init(operations: MQOperation ...) {
        self.operations = operations
    }
    
    public override func main() {
        defer {
            self.closeOperation()
        }
        
        if self.cancelled {
            return
        }
        
        for i in 0..<self.operations.count {
            let currentOperation = self.operations[i]
            currentOperation.returnBlock = nil
            currentOperation.finishBlock = nil
            if self.failureBlock != nil {
                currentOperation.failureBlock = nil
            }
            
            if i == 0 {
                currentOperation.startBlock = self.startBlock
            }
            
            // Configure the success block chain.
            // If there are more operations in the chain, set the successBlock to fire its
            // custom logic and then execute the next operation.
            // Otherwise, run the returnBlock, then the success logic,
            // and then the finishBlock.
            let customSuccessBlock = currentOperation.successBlock
            if i + 1 < self.operations.count {
                currentOperation.successBlock = {[unowned self] result in
                    customSuccessBlock?(result)
                    let nextOperation = self.operations[i + 1]
                    self.operationQueue.addOperation(nextOperation)
                }
            } else {
                currentOperation.successBlock = {[unowned self] result in
                    self.runReturnBlock()
                    customSuccessBlock?(result)
                    self.runFinishBlock()
                }
            }
            
            // Override the failureBlock.
            currentOperation.failureBlock = {[unowned self] error in
                self.runReturnBlock()
                self.runFailureBlockWithError(error)
                self.runFinishBlock()
            }
            
            if self.cancelled {
                return
            }
        }
        
        if let firstOperation = self.operations.first {
            self.operationQueue.addOperation(firstOperation)
            
            // Exit main() only when all operations in the chain are finished.
            self.operationQueue.waitUntilAllOperationsAreFinished()
        }
    }
    
    public override func cancel() {
        // Cancelling a chained operation cancels all operations in the chain.
        self.operationQueue.cancelAllOperations()
        
        super.cancel()
    }
    
}