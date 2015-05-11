//
//  MQDispatcher.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/23/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQDispatcher {
    
    /**
    Executes the specified block in the main thread and waits until it returns.
    The function guarantees that no deadlocks will occur. If the current thread is the main
    thread, it executes there. If it isn't, the block is dispatched to the main thread.
    */
    public class func syncRunInMainThread(block: () -> Void) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                block()
            }
        }
    }
    
    public class func asyncRunInMainThread(block: () -> Void) {
        if NSThread.isMainThread() {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                block()
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                block()
            }
        }
    }
    
    public class func asyncRunInBackgroundThread(block: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            block()
        }
    }
    
    @availability(*, deprecated=1.3, message="Use asyncRunInBackgroundThread()")
    public class func executeInBackgroundThread(block: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            block()
        }
    }
    
    @availability(*, deprecated=1.3, message="")
    public class func executeInMainThreadSynchronously(block: () -> Void) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                block()
            }
        }
    }
    
    @availability(*, deprecated=1.2, message="")
    public class func executeInMainThread(block: () -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            block()
        })
    }
    
}