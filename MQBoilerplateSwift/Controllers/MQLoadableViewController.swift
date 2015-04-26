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
    public var retryView: UIView?
    public var primaryView: UIView?
    
    public var operation: MQHTTPOperation? {
        didSet {
            if let operation = self.operation {
                // Override the startBlock to automatically show the loading view.
                let customStartBlock = operation.startBlock
                operation.startBlock = {[unowned self] in
                    if let theCustomStartBlock = customStartBlock {
                        theCustomStartBlock()
                    }
                    
                    MQDispatcher.executeInMainThread {[unowned self] in
                        self.showView(.Loading)
                    }
                }
                
                // Override the successBlock to automatically show
                // the primary view when successful.
                let customSuccessBlock = operation.successBlock
                operation.successBlock = {[unowned self] result in
                    if let theCustomSuccessBlock = customSuccessBlock {
                        theCustomSuccessBlock(result)
                    }
                    
                    MQDispatcher.executeInMainThread {[unowned self] in
                        self.showView(.Primary)
                    }
                }
                
                // Override the failureBlock to automatically show the
                // retry view when failed.
                let customFailureBlock = operation.failureBlock
                operation.failureBlock = {[unowned self] error in
                    if let theCustomFailureBlock = customFailureBlock {
                        theCustomFailureBlock(error)
                    }
                    
                    MQDispatcher.executeInMainThread {[unowned self] in
                        self.showView(.Retry)
                    }
                }
            }
        }
    }
    
    public enum View {
        case Loading, Retry, Primary
    }
    
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
        
        mainView.addSubviewsAndFill(self.loadingView!, self.retryView!)
        if let primaryView = self.primaryView {
            mainView.addSubviewAndFill(primaryView)
        }
    }
    
    public func setupLoadingView() {
        self.loadingView = MQLoadingView()
    }
    
    public func setupRetryView() {
        self.retryView = MQRetryView()
    }
    
    public func setupPrimaryView() {
        
    }
    
    /**
    Override to set the view controller's `self.operation`. Once `self.operation`
    is set, its start, success, and failure blocks will be overridden by the property
    observers to automatically show the appropriate views.
    */
    public func setupOperation() {
        fatalError("\(__FUNCTION__) must be overridden.")
    }
    
    /**
    Adds the operation into the shared `MQHTTPOperationQueue`.
    */
    public func startOperation() {
        if let operation = self.operation {
            MQHTTPOperationQueue.sharedQueue.addOperation(operation)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showView(.Loading)
        
        if let retryView = self.retryView as? MQRetryView {
            retryView.delegate = self
        }
        
        self.setupOperation()
        self.startOperation()
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
    }
    
}

extension MQLoadableViewController : MQRetryViewDelegate {
    
    func MQRetryViewRetryButtonTapped() {
        self.setupOperation()
        self.startOperation()
    }
    
}
