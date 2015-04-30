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
                
                // Override the successBlock to automatically show
                // the primary view when successful.
                let someCustomSuccessBlock = request.successBlock
                request.successBlock = {[unowned self] result in
                    if let customSuccessBlock = someCustomSuccessBlock {
                        customSuccessBlock(result)
                    }
                    self.showView(.Primary)
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
        self.retryView = MQDefaultRetryView()
    }
    
    public func setupPrimaryView() {
        
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
        
        self.showView(.Loading)
        
        if let retryView = self.retryView as? MQDefaultRetryView {
            retryView.internalDelegate = self
        }
        
//        self.setupOperation()
//        self.startOperation()
        self.setupRequest()
        self.startRequest()
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

extension MQLoadableViewController : MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry() {
//        self.setupOperation()
//        self.startOperation()
        self.setupRequest()
        self.startRequest()
    }
    
}
