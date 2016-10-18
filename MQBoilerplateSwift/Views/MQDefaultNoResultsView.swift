//
//  MQDefaultNoResultsView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/1/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQDefaultNoResultsView: MQNoResultsView {
    
    open var noResultsLabel: UILabel
    
    open override var text: String? {
        didSet {
            if let text = self.text {
                self.noResultsLabel.text = text
                self.setNeedsLayout()
            }
        }
    }
    
    public init() {
        self.noResultsLabel = UILabel()
        self.noResultsLabel.numberOfLines = 0
        self.noResultsLabel.lineBreakMode = .byWordWrapping
        self.noResultsLabel.text = "No results found."
        self.noResultsLabel.textAlignment = .center
        
        super.init(frame: CGRect.zero)
        
        self.addSubview(self.noResultsLabel)
        self.addAutolayout()
        
        self.backgroundColor = UIColor.white
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        // The noResultsLabel is centered vertically,
        // with a width 2/3 that of its superview.
        self.noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints([
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 2.0 / 3.0,
                constant: 0)
            ])
    }
    
}

