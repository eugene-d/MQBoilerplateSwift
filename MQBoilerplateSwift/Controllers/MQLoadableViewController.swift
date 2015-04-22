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
    
    public var command: MQCommand? {
        didSet {
            if let command = self.command {
                // Override the successBlock to automatically show
                // the primary view when successful.
                let customSuccessBlock = command.successBlock
                command.successBlock = {[unowned self] result in
                    if let theCustomSuccessBlock = customSuccessBlock {
                        theCustomSuccessBlock(result)
                    }
                    
                    self.showView(.Primary)
                }
                
                // Override the failureBlock to automatically show the
                // retry view when failed.
                let customFailureBlock = command.failureBlock
                command.failureBlock = {[unowned self] error in
                    if let theCustomFailureBlock = customFailureBlock {
                        theCustomFailureBlock(error)
                    }
                    
                    self.showView(.Retry)
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
    
    public func setupCommand() {
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let retryView = self.retryView as? MQRetryView {
            retryView.delegate = self
        }
        
        self.setupCommand()
        self.executeCommand()
    }
    
    public func executeCommand() {
        if let command = self.command {
            self.showView(.Loading)
            command.execute()
        } else {
            self.showView(.Primary)
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
    }
    
}

extension MQLoadableViewController : MQRetryViewDelegate {
    
    func MQRetryViewRetryButtonTapped() {
        self.executeCommand()
    }
    
}
