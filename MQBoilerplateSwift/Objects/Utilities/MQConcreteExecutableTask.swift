//
//  MQConcreteExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/26/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQConcreteExecutableTask: MQExecutableTask {
    
    public var type: MQExecutableTaskType {
        return .Default
    }
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public init() {}
    
    public func begin() {
        self.runStartBlock()
        self.mainProcess()
    }
    
    public func mainProcess() {
        
    }
    
    public func runStartBlock() {
        MQExecutableTaskBlockRunner.runStartBlockOfTask(self)
    }
    
    public func runReturnBlock() {
        MQExecutableTaskBlockRunner.runReturnBlockOfTask(self)
    }
    
    public func runSuccessBlockAndFinish(#result: Any?) {
        MQExecutableTaskBlockRunner.runSuccessBlockOfTaskAndFinish(self, withResult: result)
    }
    
    public func runFailureBlockAndFinish(#error: NSError) {
        MQExecutableTaskBlockRunner.runFailureBlockOfTaskAndFinish(self, withError: error)
    }
    
    public func runFinishBlock() {
        MQExecutableTaskBlockRunner.runFinishBlockOfTask(self)
    }
    
    public func overrideFailureBlockToShowErrorDialogInPresenter(presenter: UIViewController) {
        MQExecutableTaskBlockRunner.overrideFailureBlockOfTask(self,
            toShowErrorDialogInPresenter: presenter)
    }
    
}