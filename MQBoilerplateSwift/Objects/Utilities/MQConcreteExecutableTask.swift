//
//  MQConcreteExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/26/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQConcreteExecutableTask: MQExecutableTask {
    
    open var type: MQExecutableTaskType {
        return .default
    }
    
    open var startBlock: (() -> Void)?
    open var returnBlock: (() -> Void)?
    open var failureBlock: ((NSError) -> Void)?
    open var successBlock: ((Any?) -> Void)?
    open var finishBlock: (() -> Void)?
    
    public init() {}
    
    open func begin() {
        self.runStartBlock()
        self.mainProcess()
    }
    
    open func mainProcess() {
        
    }
    
    open func runStartBlock() {
        MQExecutableTaskBlockRunner.runStartBlockOfTask(self)
    }
    
    open func runReturnBlock() {
        MQExecutableTaskBlockRunner.runReturnBlockOfTask(self)
    }
    
    open func runSuccessBlockAndFinish(result: Any?) {
        MQExecutableTaskBlockRunner.runSuccessBlockOfTaskAndFinish(self, withResult: result)
    }
    
    open func runFailureBlockAndFinish(error: NSError) {
        MQExecutableTaskBlockRunner.runFailureBlockOfTaskAndFinish(self, withError: error)
    }
    
    open func runFinishBlock() {
        MQExecutableTaskBlockRunner.runFinishBlockOfTask(self)
    }
    
    open func overrideFailureBlockToShowErrorDialogInPresenter(_ presenter: UIViewController) {
        MQExecutableTaskBlockRunner.overrideFailureBlockOfTask(self,
            toShowErrorDialogInPresenter: presenter)
    }
    
}
