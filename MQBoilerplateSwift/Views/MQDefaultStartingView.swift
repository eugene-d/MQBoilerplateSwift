//
//  MQDefaultStartingView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/1/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQDefaultStartingView: MQStartingView {
    
    open var startingTextLabel: UILabel
    
    open override var text: String? {
        didSet {
            if let text = self.text {
                self.startingTextLabel.text = text
                self.setNeedsLayout()
            }
        }
    }
    
    public init() {
        self.startingTextLabel = UILabel()
        self.startingTextLabel.numberOfLines = 0
        self.startingTextLabel.lineBreakMode = .byWordWrapping
        self.startingTextLabel.text = "Nothing here yet."
        self.startingTextLabel.textAlignment = .center
        
        super.init(frame: CGRect.zero)
        
        self.addSubview(self.startingTextLabel)
        self.backgroundColor = UIColor.white
        self.addAutolayout()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        // The startingTextLabel is centered vertically,
        // with a width 2/3 that of its superview.
        self.startingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints([
            NSLayoutConstraint(item: self.startingTextLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.startingTextLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.startingTextLabel,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 2.0 / 3.0,
                constant: 0)
            ])
    }
    
}
