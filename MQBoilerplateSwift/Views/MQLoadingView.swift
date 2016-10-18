//
//  MQLoadingView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQLoadingView: UIView {

    var spinnerView: UIActivityIndicatorView
    var loadingLabel: UILabel
    var containerView: UIView
    
    open var text: String? {
        didSet {
            if let text = self.text {
                self.loadingLabel.text = text
            } else {
                self.loadingLabel.text = ""
            }
            self.setNeedsLayout()
        }
    }
    
    public init() {
        self.spinnerView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        self.loadingLabel = UILabel()
        self.loadingLabel.text = "Loading"
        self.loadingLabel.numberOfLines = 0
        self.loadingLabel.lineBreakMode = .byWordWrapping
        self.loadingLabel.textAlignment = .center
        
        self.containerView = UIView()
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        
        self.containerView.addSubviews(self.spinnerView, self.loadingLabel)
        self.addSubviews(self.containerView)
        self.addAutolayout()
        
        self.spinnerView.startAnimating()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        UIView.disableAutoresizingMasksInViews(
            self.spinnerView,
            self.loadingLabel,
            self.containerView)
        
        self.addAutolayoutInContainerView()
        self.addAutolayoutInMainView()
    }
    
    func addAutolayoutInContainerView() {
        let views = ["loadingLabel" : self.loadingLabel,
            "spinnerView" : self.spinnerView,
            "containerView" : self.containerView]
        
        let rules = ["H:|-0-[loadingLabel]-0-|",
            "V:|-0-[spinnerView]-0-[loadingLabel]-0-|"]
        
        self.containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormatArray(rules, metrics: nil, views: views))
        
        // Center the spinner view horizontally.
        
        self.containerView.addConstraint(
            NSLayoutConstraint(item: self.spinnerView,
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
                constant: 0),
            NSLayoutConstraint(item: self.containerView,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 2.0 / 3,
                constant: 0)
            ])
    }

}
