//
//  UIView+MQBoilerplateSwiftExtensions.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public extension UIView {

    public class func disableAutoresizingMasksInViews(views: UIView...) {
        for view in views {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
    }
    
    /**
    Adds multiple subviews in order. Later arguments are placed on top of the views
    preceding them.
    */
    public func addSubviews(views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
}