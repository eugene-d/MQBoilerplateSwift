//
//  MQSetupViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQSetupViewController : UIViewController {
    
    public var setupCommand: MQCommand
    
    var activityIndicator: UIActivityIndicatorView
    
    public init(setupCommand: MQCommand) {
        self.setupCommand = setupCommand
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = UIView()
        self.view.addSubview(self.activityIndicator)
        
        // Add Autolayout rules.
        
        UIView.disableAutoresizingMasksInViews(activityIndicator)
        
        // Center the loadingView.
        self.view.addConstraints([
            NSLayoutConstraint(item: activityIndicator,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: activityIndicator,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0),
            ])
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.setupCommand.execute()
    }
    
}

