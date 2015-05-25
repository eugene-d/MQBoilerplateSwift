//
//  MQLoadingOverlayViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

@availability(*, deprecated=1.5, message="Replace with showLoadingOverlay() from the UIViewController extension.")
public class MQLoadingOverlayViewController : UIViewController {
    
    public lazy var loadingOverlay: UIView = MQLoadingOverlay()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingOverlay(false)
    }
    
}