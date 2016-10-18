//
//  MQStartupViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQStartupViewController : UIViewController {
    
    open var operation: Operation?
    
    lazy var operationQueue = OperationQueue()
    lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate var isComingFromViewDidLoad = true
    
//    public init(operation: NSOperation) {
//        self.operation = operation
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    public required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    open override func loadView() {
        self.view = UIView()
        self.view.addSubview(self.activityIndicator)
        
        // Add Autolayout rules.
        
        UIView.disableAutoresizingMasksInViews(activityIndicator)
        
        // Center the loadingView.
        self.view.addConstraints([
            NSLayoutConstraint(item: activityIndicator,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: activityIndicator,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            ])
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if appearing for the first time.
        if self.isComingFromViewDidLoad {
            
            // Execute the operation if it has been assigned in viewDidLoad.
            // We put the logic inside viewWillAppear so that viewDidLoad can be
            // overridden normally.
            if let operation = self.operation {
                self.operationQueue.addOperation(operation)
            }
            
            self.isComingFromViewDidLoad = false
        }
    }
    
}

