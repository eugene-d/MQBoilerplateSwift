//
//  MQLoadingOverlayViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQLoadingOverlayViewController : UIViewController {
    
    public var loadingOverlay: UIView
    public var primaryView: UIView?
    
    public init() {
        self.loadingOverlay = MQLoadingOverlay()
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let mainView = UIView()
        self.view = mainView
        
        self.setupPrimaryView()
        if let primaryView = self.primaryView {
            mainView.addSubviewAndFill(primaryView)
        }
        
        mainView.addSubviewAndFill(self.loadingOverlay)
    }
    
    public func setupPrimaryView() {
        self.primaryView = nil
    }
    
    public func showLoadingOverlay(show: Bool) {
        self.loadingOverlay.hidden = show == false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let primaryView = self.primaryView {
            self.showLoadingOverlay(false)
        }
    }
    
}