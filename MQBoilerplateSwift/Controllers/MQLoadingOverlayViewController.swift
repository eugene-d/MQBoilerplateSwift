//
//  MQLoadingOverlayViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQLoadingOverlayViewController : UIViewController {
    
    public lazy var loadingOverlay: UIView = MQLoadingOverlay()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showLoadingOverlay(show: Bool) {
        if let appDelegate = UIApplication.sharedApplication().delegate,
            let someWindow = appDelegate.window,
            let window = someWindow {
                if show {
                    window.addSubviewAndFill(self.loadingOverlay)
                } else {
                    self.loadingOverlay.removeFromSuperview()
                }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadingOverlay(false)
    }
    
    // MARK: Deprecated
    
    @availability(*, deprecated=1.3, message="")
    public var primaryView: UIView?
    
    @availability(*, deprecated=1.3, message="")
    public func setupPrimaryView() {
        self.primaryView = nil
    }
    
}