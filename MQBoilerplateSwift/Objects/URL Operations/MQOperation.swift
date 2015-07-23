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
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public override func main() {
        defer {
            print("finishing MQOperation: \(self.classForCoder.description())")
            self.runFinishBlock()
        }
        
        print("running op: \(self.classForCoder.description())")
        
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
            self.runFailureBlockWithError(error as NSError)
        }
    }
    
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
    
    public func runFailureBlockWithError(error: NSError) {
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
        let someCustomFailureBlock = self.failureBlock
        self.failureBlock = { error in
            if self.cancelled {
                return
            }
            
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            
            if self.cancelled {
                return
            }
            
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
    deinit {
        print("deallocing: \(self.classForCoder.description())")
    }
    
}