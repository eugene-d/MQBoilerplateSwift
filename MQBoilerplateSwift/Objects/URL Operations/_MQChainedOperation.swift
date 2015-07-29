//
//  _MQChainedOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
Executes a chain of `MQOperation`s if all of them succeed; otherwise, automatically handles failure
if any of the operations in the chain fail.

Except for the `successBlock`, all the callback blocks of all operations in the chain are overridden
by the callback blocks of the `MQChainedOperation`. Individual operations often have their own
logic for processing results. However, the entire chain needs to perform the same UI callbacks
regardless of which operation in the chain terminates the chain.
*/
class _MQChainedOperation: MQAsynchronousOperation {
    
    var operationQueue = NSOperationQueue()
    
    var items: [Any]
    
    init(_ items: Any ...) {
        self.items = items
    }
    
    override func main() {
        defer {
            self.closeOperation()
        }
        
        if self.cancelled {
            return
        }
        
        // This loop builds the chain.
        
        for i in 0..<self.items.count {
            guard self.items[i] is MQOperation || self.items[i] is (MQOperation, () -> Bool) else {
                fatalError("Found unrecognised type \(self.items[i]) in the operation chain")
            }
            
            let currentItem = self.items[i]
            
            self.overrideCallbackBlocks(currentItem)
            
            if i == 0 {
                let operation = operationFromItem(currentItem)
                operation.startBlock = self.startBlock
            }
            
            if i + 1 < self.items.count {
                self.link(currentItem, nextItem: self.items[i + 1])
            } else {
                self.concludeWithItem(currentItem)
            }
            
            if self.cancelled {
                return
            }
        }
        
        if let firstItem = self.items.first {
            let operation = operationFromItem(firstItem)
            self.operationQueue.addOperation(operation)
            
            // Exit main() only when all operations in the chain are finished.
            self.operationQueue.waitUntilAllOperationsAreFinished()
        }
    }
    
    override func cancel() {
        // Cancelling a chained operation cancels all operations in the chain.
        self.operationQueue.cancelAllOperations()
        
        super.cancel()
    }
    
    /**
    Disregards the callback blocks of the individual operations in the chain to adopt the
    chain's callback blocks instead.
    */
    func overrideCallbackBlocks(item: Any) {
        let operation = operationFromItem(item)
        operation.returnBlock = nil
        operation.finishBlock = nil
        operation.failureBlock = {[unowned self] error in
            self.runReturnBlock()
            self.runFailureBlockWithError(error)
            self.runFinishBlock()
        }
    }
    
    /**
    Links two items in the chain. If the second argument is nil, it is assumed that the first argument
    is the end of the chain and its `successBlock` will contain logic to wrap up the chain instead of
    chaining to another operation.
    */
    func link(item: Any, nextItem: Any) {
        let operation = operationFromItem(item)
        let nextOperation = operationFromItem(nextItem)
        let condition = conditionFromItem(nextItem)
        self.link(op1: operation, op2: nextOperation, condition: condition)
    }
    
    func concludeWithItem(item: Any) {
        let operation = operationFromItem(item)
        let customSuccessBlock = operation.successBlock
        operation.successBlock = {[unowned self] result in
            self.runReturnBlock()
            customSuccessBlock?(result)
            self.successBlock?(result)
            self.runFinishBlock()
        }
    }
    
    /**
    Links two operations. If a condition is provided, the second operation is chained
    only if the condition evaluates to true.
    */
    func link(op1 op1: MQOperation, op2: MQOperation, condition: (() -> Bool)?) {
        let customSuccessBlock = op1.successBlock
        op1.successBlock = {[unowned self] result in
            customSuccessBlock?(result)
            if let condition = condition {
                if condition() == true {
                    self.operationQueue.addOperation(op2)
                }
            } else {
                self.operationQueue.addOperation(op2)
            }
        }
    }
    
}

private func operationFromItem(item: Any) -> MQOperation {
    if let operation = item as? MQOperation {
        return operation
    } else if let (operation, _) = item as? (MQOperation, () -> Bool) {
        return operation
    }
    fatalError("Unrecognized type: \(item)")
}

private func conditionFromItem(item: Any) -> (() -> Bool)? {
    if let (_, condition) = item as? (MQOperation, () -> Bool) {
        return condition
    }
    return nil
}