//
//  MQRetryView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

/**
A separate delegate intended for the sole use of `MQLoadableViewController`
so that its child classes don't have to use the `override` keyword when implementing `MQRetryViewDelegate`.
*/
protocol MQDefaultRetryViewDelegate {
    
    func defaultRetryViewDidTapRetry()
    
}

/**
A default implementation of an `MQRetryView`.
*/
open class MQDefaultRetryView: MQRetryView {
    
    var errorLabel: UILabel
    var retryButton: UIButton
    var containerView: UIView
    
    open override var error: NSError? {
        didSet {
            if let error = self.error {
                self.errorLabel.text = error.localizedDescription
                self.setNeedsLayout()
            }
        }
    }
    
    var internalDelegate: MQDefaultRetryViewDelegate?
    
    public init() {
        self.errorLabel = UILabel()
        self.retryButton = UIButton(type: .system)
        self.containerView = UIView()
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        self.setupViews()
        self.addAutolayout()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.errorLabel.numberOfLines = 0
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.textAlignment = .center
        
        self.retryButton.setTitle("Retry", for: UIControlState())
        self.retryButton.addTarget(self, action: #selector(MQDefaultRetryView.retryButtonTapped), for: .touchUpInside)
        
        self.containerView.addSubviews(self.errorLabel, self.retryButton)
        self.addSubview(containerView)
    }
    
    func addAutolayout() {
        UIView.disableAutoresizingMasksInViews(
            self.errorLabel,
            self.retryButton,
            self.containerView)
        
        self.addAutolayoutInContainerView()
        self.addAutolayoutInMainView()
    }
    
    func addAutolayoutInContainerView() {
        let views = ["errorLabel" : self.errorLabel,
            "retryButton" : self.retryButton] as [String : Any]
        let rules = ["H:|-0-[errorLabel]-0-|",
            "V:|-0-[errorLabel]-0-[retryButton]-0-|"]
        
        self.containerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormatArray(
                rules,
                metrics: nil,
                views: views as [String : AnyObject]))
        
        // Center the Retry button horizontally.
        self.containerView.addConstraint(
            NSLayoutConstraint(item: self.retryButton,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.containerView,
                attribute: .centerX,
                multiplier: 1,
                constant: 0))
    }
    
    func addAutolayoutInMainView() {
        self.addConstraints([
            NSLayoutConstraint(item: self.containerView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.containerView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 1),
            
            // Limit the container's width to 2/3 of the main view.
            NSLayoutConstraint(item: self.containerView,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 2.0 / 3,
                constant: 0)
            ])
    }
    
    func retryButtonTapped() {
        if let internalDelegate = self.internalDelegate {
            internalDelegate.defaultRetryViewDidTapRetry()
        }
    }
    
}
