//
//  MQExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/5/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public enum MQExecutableTaskType {
    case `default`, nsOperation
}

public protocol MQExecutableTask: class {
    
    var type: MQExecutableTaskType { get }
    
    var startBlock: (() -> Void)? { get set }
    var returnBlock: (() -> Void)? { get set }
    var failureBlock: ((NSError) -> Void)? { get set }
    var successBlock: ((Any?) -> Void)? { get set }
    var finishBlock: (() -> Void)? { get set }
    
//    var result: Any? { get set }
//    var error: NSError? { get set }
    
    /**
    Starts the task. Override to define the order at which the blocks and the
    `mainProcess()` function is called.
    */
    func begin()
    
    /**
    Defines the main process of the task. Override to define how the result
    or error is generated. Must ultimately end with
    */
    func mainProcess()
    
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
    
    /**
    Implemented by subclasses to synchronously perform the `successBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    func runSuccessBlockAndFinish(result: Any?)
    
    /**
    Implemented by subclasses to synchronously perform the `failureBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    func runFailureBlockAndFinish(error: NSError)
    
    func runFinishBlock()
    
    func overrideFailureBlockToShowErrorDialogInPresenter(_ presenter: UIViewController)
    
}
