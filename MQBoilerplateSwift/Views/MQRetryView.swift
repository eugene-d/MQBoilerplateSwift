//
//  MQRetryView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQRetryView: UIControl {
    
    var errorLabel: UILabel
    var retryButton: UIButton
    var containerView: UIView
    
    public init() {
        self.errorLabel = UILabel()
        self.retryButton = UIButton.buttonWithType(.Custom) as! UIButton
        self.containerView = UIView()
        
        super.init(frame: CGRectZero)
        
        self.setupViews()
        self.addAutolayout()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.errorLabel.numberOfLines = 0
        self.errorLabel.lineBreakMode = .ByWordWrapping
        
        self.retryButton.setTitle("Retry", forState: .Normal)
        self.retryButton.addTarget(self, action: Selector("retryButtontapped"), forControlEvents: .TouchUpInside)
        
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
            "retryButton" : self.retryButton]
        let rules = ["H:|-0-[errorLabel]-0-|",
            "V:|-0-[errorLabel]-0-[retryButton]-0-|"]
        
        self.containerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormatArray(
                rules,
                metrics: nil,
                views: views))
        
        // Center the Retry button horizontally.
        self.containerView.addConstraint(
            NSLayoutConstraint(item: self.retryButton,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.containerView,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0))
    }
    
    func addAutolayoutInMainView() {
        self.addConstraints([
            NSLayoutConstraint(item: self.containerView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.containerView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1,
                constant: 1),
            
            // Limit the container's width to 2/3 of the main view.
            NSLayoutConstraint(item: self.containerView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 2.0 / 3,
                constant: 0)
            ])
    }
    
    func retryButtonTapped() {
        self.sendActionsForControlEvents(.TouchUpInside)
    }
    
}
