//
//  MQDefaultNoResultsView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/1/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQDefaultNoResultsView: MQNoResultsView {
    
    public var noResultsLabel: UILabel
    
    public override var noResultsText: String? {
        didSet {
            if let noResultsText = self.noResultsText {
                self.noResultsLabel.text = noResultsText
                self.setNeedsLayout()
            }
        }
    }
    
    public init() {
        self.noResultsLabel = UILabel()
        self.noResultsLabel.numberOfLines = 0
        self.noResultsLabel.lineBreakMode = .ByWordWrapping
        self.noResultsLabel.text = "No results found."
        self.noResultsLabel.textAlignment = .Center
        
        super.init(frame: CGRectZero)
        
        self.addSubview(self.noResultsLabel)
        self.addAutolayout()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAutolayout() {
        // The noResultsLabel is centered vertically,
        // with a width 2/3 that of its superview.
        self.noResultsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addConstraints([
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.noResultsLabel,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 2.0 / 3.0,
                constant: 0)
            ])
    }
    
}

