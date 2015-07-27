//
//  MQOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQOperation: NSOperation {
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((ErrorType) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
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
    
    public func runStartBlock() {
        guard let startBlock = self.startBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(startBlock)
    }
    
    public func runReturnBlock() {
        guard let returnBlock = self.returnBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(returnBlock)
    }
    
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
    
    public func runFinishBlock() {
        guard let finishBlock = self.finishBlock else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        MQDispatcher.syncRunInMainThread(finishBlock)
    }
    
    public func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController) {
        self.failureBlock = {[unowned presenter] error in
            if self.cancelled {
                return
            }
            
            MQErrorDialog.showError(error, inPresenter: presenter)
        }
    }
    
}