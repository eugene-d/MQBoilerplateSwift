//
//  MQLoadableViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQLoadableViewController: UIViewController {
    
    public var loadingView: UIView?
    public var retryView: MQRetryView?
    public var primaryView: UIView?
    public var noResultsView: MQNoResultsView?
    
    /**
    Determines whether the primary view is automatically shown in the request's
    success block. The default value is `false` since it is up to you to show
    either the `primaryView` or the `noResultsView` depending on the `result`
    returned by the success block. Set this to `true` if your `request` will always
    have a result.
    */
    public var automaticallyShowsPrimaryViewOnSuccess = false
    
    public enum View {
        case Loading, Retry, Primary, NoResults
    }
    
    public var request: MQAPIRequest? {
        didSet {
            if let request = self.request {
                // Override the startBlock to automatically show the loading view.
                let someCustomStartBlock = request.startBlock
                request.startBlock = {[unowned self] in
                    if let customStartBlock = someCustomStartBlock {
                        customStartBlock()
                    }
                    
                    self.showView(.Loading)
                }
                
                if self.automaticallyShowsPrimaryViewOnSuccess {
                    // Override the successBlock to automatically show
                    // the primary view when successful.
                    let someCustomSuccessBlock = request.successBlock
                    request.successBlock = {[unowned self] result in
                        if let customSuccessBlock = someCustomSuccessBlock {
                            customSuccessBlock(result)
                        }
                        self.showView(.Primary)
                    }
                }
                
                // Override the failureBlock to automatically show the
                // retry view when failed.
                let someCustomFailureBlock = request.failureBlock
                request.failureBlock = {[unowned self] error in
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
    }
    
    /**
    A flag used by `viewWillAppear:` to check if it will be the first time for
    the view controller to appear. If it is, the view controller will setup the 
    `request` and start it.
    
    This "initial" running of the `request` is written inside `viewWillAppear:`
    instead of `viewDidLoad` so that a child class can just override `viewDidLoad`
    normally and not worry about when the parent class automatically starts the `request`.
    */
    var isComingFromViewDidLoad = true
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let mainView = UIView()
        self.view = mainView
        
        // Call this class or the subclass' methods for setting up
        // the subviews.
        self.setupLoadingView()
        self.setupRetryView()
        self.setupPrimaryView()
        self.setupNoResultsView()
        
        mainView.addSubviewsAndFill(self.loadingView!, self.retryView!, self.noResultsView!)
        if let primaryView = self.primaryView {
            mainView.addSubviewAndFill(primaryView)
        }
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
    
    public func setupRequest() {
        
    }
    
    public func startRequest() {
        if let request = self.request {
            request.start()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showView(.NoResults)
        
        if let retryView = self.retryView as? MQDefaultRetryView {
            retryView.internalDelegate = self
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isComingFromViewDidLoad {
            self.setupRequest()
            self.startRequest()
            self.isComingFromViewDidLoad = false
        }
    }
    
    public func showView(view: MQLoadableViewController.View) {
        if let loadingView = self.loadingView {
            loadingView.hidden = view != .Loading
        }
        
        if let retryView = self.retryView {
            retryView.hidden = view != .Retry
        }
        
        if let primaryView = self.primaryView {
            primaryView.hidden = view != .Primary
        }
        
        if let noResultsView = self.noResultsView {
            noResultsView.hidden = view != .NoResults
        }
    }
    
}

extension MQLoadableViewController : MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry() {
        self.setupRequest()
        self.startRequest()
    }
    
}
