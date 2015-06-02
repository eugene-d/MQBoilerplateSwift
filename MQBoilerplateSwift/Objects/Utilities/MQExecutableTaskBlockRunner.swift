//
//  MQExecutableTaskBlockRunner.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/3/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
A class tha contains functions for executing the callback blocks of an `MQExecutableTask`.
Instances of classes that conform to `MQExecutableTask` must implement methods that perform the
callback blocks on the main UI thread. This class exists simply to put the logic of all
those functions in one place. If we didn't have this class, the implementation of the functions
here will have to be copy-pasted across any class that conforms to `MQExecutableTask`.
*/
public final class MQExecutableTaskBlockRunner {
    
    public class func runStartBlockOfTask(task: MQExecutableTask) {
        if let startBlock = task.startBlock {
            // If the task is an operation, check first if it has been cancelled.
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQDispatcher.syncRunInMainThread(startBlock)
        }
    }
    
    public class func runReturnBlockOfTask(task: MQExecutableTask) {
        if let returnBlock = task.returnBlock {
            // If the task is an operation, check first if it has been cancelled.
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQDispatcher.syncRunInMainThread(returnBlock)
        }
    }
    
    public class func runSuccessBlockOfTaskAndFinish(task: MQExecutableTask, withResult result: Any?) {
        if let successBlock = task.successBlock {
            // If the task is an operation, check first if it has been cancelled.
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQDispatcher.syncRunInMainThread {
                successBlock(result)
            }
            
            self.runFinishBlockOfTask(task)
        }
    }
    
    public class func runFailureBlockOfTaskAndFinish(task: MQExecutableTask, withError error: NSError) {
        if let failureBlock = task.failureBlock {
            // If the task is an operation, check first if it has been cancelled.
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQDispatcher.syncRunInMainThread {
                failureBlock(error)
            }
            
            self.runFinishBlockOfTask(task)
        }
    }
    
    public class func runFinishBlockOfTask(task: MQExecutableTask) {
        if let finishBlock = task.finishBlock {
            // If the task is an operation, check first if it has been cancelled.
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQDispatcher.syncRunInMainThread(finishBlock)
        }
    }
    
    public class func overrideFailureBlockOfTask(task: MQExecutableTask, toShowErrorDialogInPresenter presenter: UIViewController) {
        let someCustomFailureBlock = task.failureBlock
        task.failureBlock = { error in
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            
            if let operation = task as? MQOperation {
                if operation.cancelled {
                    return
                }
            }
            
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
}