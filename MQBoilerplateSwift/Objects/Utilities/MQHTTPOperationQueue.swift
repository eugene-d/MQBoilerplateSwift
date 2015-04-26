//
//  MQHTTPOperationQueue.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/26/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

private let _instance = MQHTTPOperationQueue()

/**
An `MQHTTPOperationQueue` displays the system's network activity indicator if it holds any operations.
Once all the operations are finished, the queue hides the network activity indicator.
*/
public class MQHTTPOperationQueue: NSOperationQueue {
    
    private let kOperationCountKeypath = "operationCount"
    
    public class var sharedQueue: MQHTTPOperationQueue {
        return _instance
    }
    
    override init() {
        super.init()
        self.name = "MQHTTPOperationQueue"
        self.addObserver(self, forKeyPath: kOperationCountKeypath, options: .New, context: nil)
    }
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == kOperationCountKeypath {
            if let newValue = change[NSKeyValueChangeNewKey] as? Int {
                if newValue > 0 {
                    MQDispatcher.executeInMainThread {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    }
                } else {
                    MQDispatcher.executeInMainThread {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: kOperationCountKeypath)
    }
    
}
