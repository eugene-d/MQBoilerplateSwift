//
//  MQLoadableViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQLoadableViewController: UIViewController {
    
    public enum View {
        case Starting, Loading, Retry, Primary, NoResults
    }
    
    public var task: MQExecutableTask?
    public var operationQueue: NSOperationQueue?
    
    public var startingView: MQStartingView!
    public var loadingView: UIView!
    public var retryView: MQRetryView!
    public var primaryView: UIView?
    public var noResultsView: MQNoResultsView!
    
    /**
    Determines whether the primary view is automatically shown in the request's
    success block. The default value is `false` since it is up to you to show
    either the `primaryView` or the `noResultsView` depending on the `result`
    returned by the success block. Set this to `true` if your `request` will always
    have a result.
    */
    public var automaticallyShowsPrimaryViewOnSuccess = false
    
    /**
    A flag used by `viewWillAppear:` to check if it will be the first time for
    the view controller to appear. If it is, the view controller will setup the 
    `request` and start it.
    
    This "initial" running of the `request` is written inside `viewWillAppear:`
    instead of `viewDidLoad` so that a child class can just override `viewDidLoad`
    normally and not worry about when the parent class automatically starts the `request`.
    */
    var isComingFromViewDidLoad = true
    
    public override func loadView() {
        let mainView = UIView()
        self.view = mainView
        
        // Call this class or the subclass' methods for setting up
        // the subviews.
        self.setupStartingView()
        self.setupLoadingView()
        self.setupRetryView()
        self.setupPrimaryView()
        self.setupNoResultsView()
        
        mainView.addSubviewsAndFill(self.startingView!, self.loadingView!, self.retryView!, self.noResultsView!)
        if let primaryView = self.primaryView {
            mainView.addSubviewAndFill(primaryView)
        }
    }
    
    public func setupStartingView() {
        self.startingView = MQDefaultStartingView()
    }
    
    public func setupLoadingView() {
        self.loadingView = MQLoadingView()
    }
    
    public func setupRetryView() {
        self.retryView = MQDefaultRetryView()
    }
    
    public func setupPrimaryView() {
        
    }
    
    public func setupNoResultsView() {
        self.noResultsView = MQDefaultNoResultsView()
    }
    
    public func setupTask() {
        
    }
    
    public func startTask() {
        self.overrideTaskBlocks()
        
        if let task = self.task {
            if let request = task as? MQAPIRequest {
                request.start()
            } else if let operation = task as? MQOperation {
                if let operationQueue = self.operationQueue {
                    operationQueue.addOperation(operation)
                }
            }
        }
    }
    
    public func restartTask() {
        self.setupTask()
        self.startTask()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showView(.Starting)
        
        if let retryView = self.retryView as? MQDefaultRetryView {
            retryView.internalDelegate = self
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isComingFromViewDidLoad {
            self.restartTask()
            self.isComingFromViewDidLoad = false
        }
    }
    
    public func showView(view: MQLoadableViewController.View) {
        self.startingView.hidden = view != .Starting
        self.loadingView.hidden = view != .Loading
        self.retryView.hidden = view != .Retry
        
        if let primaryView = self.primaryView {
            primaryView.hidden = view != .Primary
        }
        
        self.noResultsView.hidden = view != .NoResults
    }
    
    func overrideTaskBlocks() {
        if let task = self.task {
            // Override the startBlock to automatically show the loading view.
            let someCustomStartBlock = task.startBlock
            task.startBlock = {[unowned self] in
                if let customStartBlock = someCustomStartBlock {
                    customStartBlock()
                }
                
                self.showView(.Loading)
            }
            
            if self.automaticallyShowsPrimaryViewOnSuccess {
                // Override the successBlock to automatically show
                // the primary view when successful.
                let someCustomSuccessBlock = task.successBlock
                task.successBlock = {[unowned self] result in
                    if let customSuccessBlock = someCustomSuccessBlock {
                        customSuccessBlock(result)
                    }
                    self.showView(.Primary)
                }
            }
            
            // Override the failureBlock to automatically show the
            // retry view when failed.
            let someCustomFailureBlock = task.failureBlock
            task.failureBlock = {[unowned self] error in
                if let customFailureBlock = someCustomFailureBlock {
                    customFailureBlock(error)
                }
                
                if let retryView = self.retryView {
                    retryView.error = error
                    self.showView(.Retry)
                }
            }
        }
    }
    
    // MARK: DEPRECATED
    
    @availability(*, deprecated=1.2, message="Use task instead.")
    public var request: MQAPIRequest?
    
    @availability(*, deprecated=1.2, message="Use task instead.")
    public var operation: MQOperation?
    
    @availability(*, deprecated=1.2, message="Use setupTask() instead.")
    public func setupRequest() {
        
    }
    
    @availability(*, deprecated=1.2, message="Use startTask() instead.")
    public func startRequest() {
        if let request = self.request {
            request.start()
        }
    }
    
    @availability(*, deprecated=1.2, message="Use setupTask() instead.")
    public func setupOperation() {
        
    }
    
    @availability(*, deprecated=1.2, message="Use startTask() instead.")
    public func startOperation() {
        if let operation = self.operation,
            let operationQueue = self.operationQueue {
                operationQueue.addOperation(operation)
        }
    }
    
}

extension MQLoadableViewController : MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry() {
        self.restartTask()
    }
    
}
