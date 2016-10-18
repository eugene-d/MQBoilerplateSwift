//
//  MQButton.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/8/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

/**
A custom button implementation where you can just set the background color
which is automatically darkened when pressed. If you want a label or an image
in the button, you can use `MQLabelButton` or `MQImageButton` instead, respectively.
*/
open class MQButton: UIControl {
    
    /**
    The view that is used to darken the entire button when pressed.
    */
    open var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.3
        overlayView.isUserInteractionEnabled = false
        return overlayView
    }()
    
    /**
    The custom view for the button. If you want to put a label or an image
    in the button, subclass `MQButton` and make your label or image a filling
    subview of `customView`.
    */
    open var customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = UIColor.clear
        customView.isUserInteractionEnabled = false
        return customView
    }()
    
    public init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.addSubviewsAndFill(self.customView, self.overlayView)
        
        // Initially, the darkView shouldn't be showing.
        self.overlayView.isHidden = true
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.overlayView.isHidden = false
        return true
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.overlayView.isHidden = true
    }
    
    open override func cancelTracking(with event: UIEvent?) {
        self.overlayView.isHidden = true
    }
    
}
