//
//  MQChainedOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 04/02/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

/**
 The chain's `returnBlock` and `failBlock` overrides those of the operations in the chain.
 */
public class MQChainedOperation: MQOperation {
    
    var queue = NSOperationQueue()
    var operations = [MQOperation]()
    
    public func append<T: MQOperation>(operation: T, validator: (Any? -> Bool)? = nil, configurator: ((T, Any?) -> Void)? = nil) {
        defer {
            self.operations.append(operation)
        }
        
        operation.startBlock = nil
        operation.returnBlock = self.returnBlock
        operation.failBlock = {[unowned self] error in
            self.runReturnBlock()
            self.runFailBlock(error)
        }
        
        if self.operations.isEmpty {
            // If this is the first operation in the chain, nothing else needs to be done.
            return
        }
        
        guard let tail = self.operations.last
            else {
                return
        }
        
        let tailSuccessBlock = tail.successBlock
        tail.successBlock = {[unowned self] result in
            guard validator?(result) == true || validator == nil
                else {
                    tail.runReturnBlock()
                    tailSuccessBlock?(result)
                    return
            }
            
            tailSuccessBlock?(result)
            configurator?(operation, result)
            self.queue.addOperation(operation)
        }
    }
    
    public override func main() {
        defer {
            self.closeOperation()
        }
        
        guard let head = self.operations.first
            else {
                return
        }
        
        self.runStartBlock()
        self.queue.addOperation(head)
        self.queue.waitUntilAllOperationsAreFinished()
    }
    
}