//
//  UIView.swift
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
    public func addSubviews(views: UIView ...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    public func addSubviewsAndFill(views: UIView ...) {
        for view in views {
            self.addSubviewAndFill(view)
        }
    }
    
    public func addSubviewAndFill(view: UIView) {
        self.addSubview(view)
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let views = ["view" : view]
        let rules = ["H:|-0-[view]-0-|",
            "V:|-0-[view]-0-|"]
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormatArray(rules,
                metrics: nil,
                views: views))
    }
    
    public class func instantiateFromNib<T: UIView>() -> T? {
        if let className = self.className() {
            let mainBundle = NSBundle.mainBundle()
            if let objects = mainBundle.loadNibNamed(className, owner: self, options: nil) {
                if let view = objects.last as? T {
                    return view
                }
            }
        }
        return nil
    }
    
    public class func nib() -> UINib? {
        if let className = self.className() {
            return UINib(nibName: className, bundle: nil)
        }
        return nil
    }
    
    /**
    Returns the name of this class based on a (poor?) assumption that it is the last
    token in the fully qualified class name assigned by Swift.
    */
    class func className() -> String? {
        let description = self.classForCoder().description()
        if let className = description.componentsSeparatedByString(".").last {
            return className
        }
        return nil
    }
    
}