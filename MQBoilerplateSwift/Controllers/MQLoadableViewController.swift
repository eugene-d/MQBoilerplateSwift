//
//  MQLoadableViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQLoadableViewController: UIViewController {
    
    public enum View {
        case starting, loading, retry, primary, noResults
    }
    
    open var task: MQExecutableTask?
    open lazy var operationQueue = OperationQueue()
    
    open var startingView: MQStartingView!
    open var loadingView: UIView!
    open var retryView: MQRetryView!
    open var primaryView: UIView?
    open var noResultsView: MQNoResultsView!
    
    /**
    Determines whether the `successBlock` should be overridden to automatically
    show the primary view.
    
    The default value is `false` since it is up to you to define whether the `primaryView`
    or the `noResultsView` will be displayed upon receiving the result. However, if
    the result you are expecting does not have a "no results" state (i.e., it is not an
    array that may have no elements), you can set this to true to show the `primaryView`
    in the `successBlock`.
    */
    open var automaticallyShowsPrimaryViewOnSuccess = false
    
    /**
    A flag used by `viewWillAppear:` to check if it will be the first time for
    the view controller to appear. If it is, the view controller will setup the 
    `request` and start it.
    
    This initial run of the `request` is written inside `viewWillAppear:`
    instead of `viewDidLoad` so that a child class can just override `viewDidLoad`
    normally and not worry about when the parent class automatically starts the `request`.
    */
    var isComingFromViewDidLoad = true
    
    open override func loadView() {
        let mainView = UIView()
        self.view = mainView
        
        // Call this class or the subclass' methods for setting up
        // the subviews.
        self.setupStartingView()
        self.setupLoadingView()
        self.setupRetryView()
        self.setupPrimaryView()
        self.setupNoResultsView()
        
        mainView.addSubviews(self.startingView, self.loadingView, self.retryView, self.noResultsView)
        if let primaryView = self.primaryView {
            mainView.addSubview(primaryView)
        }
    }
    
    open func setupStartingView() {
        if self.startingView == nil {
            self.startingView = MQDefaultStartingView()
        }
    }
    
    open func setupLoadingView() {
        if self.loadingView == nil {
            self.loadingView = MQLoadingView()
        }
    }
    
    open func setupRetryView() {
        if self.retryView == nil {
            self.retryView = MQDefaultRetryView()
        }
    }
    
    open func setupPrimaryView() {
        
    }
    
    open func setupNoResultsView() {
        if self.noResultsView == nil {
            self.noResultsView = MQDefaultNoResultsView()
        }
    }
    
    open func setupViewConstraints() {
        self.startingView.fillSuperview()
        self.loadingView.fillSuperview()
        self.retryView.fillSuperview()
        self.noResultsView.fillSuperview()
        
        if let primaryView = self.primaryView {
            primaryView.fillSuperview()
        }
    }
    
    open func setupTask() {
        
    }
    
    open func startTask() {
        if var task = self.task {
            self.overrideTaskBlocks(&task)
            
            if task.type == .nsOperation {
                if let operation = task as? MQOperation {
                    self.operationQueue.addOperation(operation)
                }
            } else {
                task.begin()
            }
        }
    }
    
    open func restartTask() {
        self.setupTask()
        self.startTask()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewConstraints()
        
        self.showView(.starting)
        
        if let retryView = self.retryView as? MQDefaultRetryView {
            retryView.internalDelegate = self
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isComingFromViewDidLoad {
            self.restartTask()
            self.isComingFromViewDidLoad = false
        }
    }
    
    open func showView(_ view: MQLoadableViewController.View) {
        self.startingView.isHidden = view != .starting
        self.loadingView.isHidden = view != .loading
        self.retryView.isHidden = view != .retry
        
        if let primaryView = self.primaryView {
            primaryView.isHidden = view != .primary
        }
        
        self.noResultsView.isHidden = view != .noResults
    }
    
    open func overrideTaskBlocks(_ task: inout MQExecutableTask) {
        // Override the startBlock to automatically show the loading view.
        let someCustomStartBlock = task.startBlock
        task.startBlock = {[unowned self] in
            if let customStartBlock = someCustomStartBlock {
                customStartBlock()
            }
            
            self.showView(.loading)
        }
        
        if self.automaticallyShowsPrimaryViewOnSuccess {
            // Override the successBlock to automatically show
            // the primary view when successful.
            let someCustomSuccessBlock = task.successBlock
            task.successBlock = {[unowned self] result in
                if let customSuccessBlock = someCustomSuccessBlock {
                    customSuccessBlock(result)
                }
                self.showView(.primary)
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
                self.showView(.retry)
            }
        }
    }
    
}

extension MQLoadableViewController : MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry() {
        self.restartTask()
    }
    
}
