//
//  MQLoadableViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

/**
A view controller that loads and displays information based on the results of an
executable task. An `MQLoadableViewController` has five subviews, only one of which
are displayed at any given moment:

* `startingView` - The initial state of the view controller, when there is no
information yet. For example, in a blogging app, the `startingView` can tell the
user, "No posts yet! Press the add button to write your first entry."

* `loadingView` - Indicates that the executable task is running in the background.
The `loadingView`, by default, is assigned an instance of `MQLoadingView` in
`setupLoadingView()`. It contains a `UIActivityIndicatorView` and a `UILabel` that says
"Loading." However, you can override this function, not invoke this class's implementation,
and assign your own custom view, which is why the property is of type `UIView`.

* `retryView` - Displayed when the executable task produces an error. The standard
`retryView`, an instance of `MQRetryView`, contains a label that displays the error
message, and a Retry button.

* `primaryView` - The view that is displayed when there are results. An `MQLoadableViewController`
subclass should override the `setupPrimaryView()` function and set this property.

* `noResultsView` - The view that is displayed when the executable task succeeds,
but finds no results. The standard `noResultsView`, an instance of `MQNoResultsView`,
contains a `UILabel` that says there were no results found.

*/
public class MQLoadableViewController: UIViewController {
    
    public enum View {
        case Starting, Loading, Retry, Primary, NoResults
    }
    
    public var task: MQExecutableTask?
    public lazy var operationQueue = NSOperationQueue()
    
    public var startingView: MQStartingView!
    public var loadingView: UIView!
    public var retryView: MQRetryView!
    public var primaryView: UIView?
    public var noResultsView: MQNoResultsView!
    
    /**
    Determines whether the `successBlock` should be overridden to automatically
    show the primary view.
    
    The default value is `false` since it is up to you to define whether the `primaryView`
    or the `noResultsView` will be displayed upon receiving the result. However, if
    the result you are expecting does not have a "no results" state (i.e., it is not an
    array that may have no elements), you can set this to true to show the `primaryView`
    in the `successBlock`.
    */
    public var automaticallyShowsPrimaryViewOnSuccess = false
    
    /**
    A flag used by `viewWillAppear:` to check if it will be the first time for
    the view controller to appear. If it is, the view controller will setup the 
    `request` and start it.
    
    This initial run of the `request` is written inside `viewWillAppear:`
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
        
        mainView.addSubviews(self.startingView, self.loadingView, self.retryView, self.noResultsView)
        if let primaryView = self.primaryView {
            mainView.addSubview(primaryView)
        }
    }
    
    public func setupStartingView() {
        if self.startingView == nil {
            self.startingView = MQDefaultStartingView()
        }
    }
    
    public func setupLoadingView() {
        if self.loadingView == nil {
            self.loadingView = MQLoadingView()
        }
    }
    
    public func setupRetryView() {
        if self.retryView == nil {
            self.retryView = MQDefaultRetryView()
        }
    }
    
    public func setupPrimaryView() {
        
    }
    
    public func setupNoResultsView() {
        if self.noResultsView == nil {
            self.noResultsView = MQDefaultNoResultsView()
        }
    }
    
    public func setupViewConstraints() {
        self.startingView.fillSuperview()
        self.loadingView.fillSuperview()
        self.retryView.fillSuperview()
        self.noResultsView.fillSuperview()
        
        if let primaryView = self.primaryView {
            primaryView.fillSuperview()
        }
    }
    
    /**
    A callback function that you must override to set the `self.task` property.
    The task will automatically be executed once the view controller is displayed.
    */
    public func setupTask() {
        
    }
    
    public func startTask() {
        if var task = self.task {
            self.overrideTaskBlocks(&task)
            
            if task.type == .NSOperation {
                if let operation = task as? MQOperation {
                    self.operationQueue.addOperation(operation)
                }
            } else {
                task.begin()
            }
        }
    }
    
    public func restartTask() {
        self.setupTask()
        self.startTask()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewConstraints()
        
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
    
    public func overrideTaskBlocks(inout task: MQExecutableTask) {
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

extension MQLoadableViewController : MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry() {
        self.restartTask()
    }
    
}
