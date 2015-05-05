//
//  MQExecutableTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/5/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public enum MQExecutableTaskType {
    case NSURLSessionTask, NSOperation
}

public protocol MQExecutableTask: class {
    
    var type: MQExecutableTaskType { get }
    
    var startBlock: (() -> Void)? { get set }
    var returnBlock: (() -> Void)? { get set }
    var failureBlock: ((NSError) -> Void)? { get set }
    var successBlock: ((AnyObject?) -> Void)? { get set }
    var finishBlock: (() -> Void)? { get set }
    
    /**
    Implemented by subclasses to synchronously perform the `returnBlock` in the main thread
    if it exists, and waits for it to return before proceeding.
    */
    func performReturn()
    
    /**
    Implemented by subclasses to synchronously perform the `successBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    func performSuccessWithResult(result: AnyObject?)
    
    /**
    Implemented by subclasses to synchronously perform the `failureBlock` and
    then the `finishBlock` in the main thread if they exist.
    */
    func performFailureWithError(error: NSError)
    
}