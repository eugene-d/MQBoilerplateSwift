//
//  MQConfirmDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/8/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQConfirmDialog {
    
    @availability(*, deprecated=1.10)
    public var title: String
    
    @availability(*, deprecated=1.10)
    public var message: String
    
    @availability(*, deprecated=1.10)
    public var confirmButtonTitle: String
    
    @availability(*, deprecated=1.10)
    public var cancelButtonTitle: String
    
    @availability(*, deprecated=1.10)
    public init() {
        self.title = "Confirm"
        self.message = "Are you sure?"
        self.confirmButtonTitle = "Yes"
        self.cancelButtonTitle = "Cancel"
    }
    
    @availability(*, deprecated=1.10)
    public func showInPresenter(presenter: UIViewController, confirmAction someAction: (() -> Void)?) {
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .Alert)
        
        let confirmButtonAction = UIAlertAction(title: self.confirmButtonTitle,
            style: .Default) {[unowned self] _ in
                if let confirmAction = someAction {
                    confirmAction()
                }
                alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(confirmButtonAction)
        
        let cancelAction = UIAlertAction(title: self.cancelButtonTitle,
            style: UIAlertActionStyle.Cancel) {[unowned self] _ in
                alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        presenter.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public class func showInPresenter(presenter: UIViewController,
        title: String = "Confirm",
        message: String = "Are you sure?",
        confirmButtonTitle: String = "Yes",
        cancelButtonTitle: String = "Cancel",
        confirmAction someAction: (() -> ())?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let confirmButtonAction = UIAlertAction(title: confirmButtonTitle,
                style: .Default) { _ in
                    if let confirmAction = someAction {
                        confirmAction()
                    }
                    alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(confirmButtonAction)
            
            let cancelAction = UIAlertAction(title: cancelButtonTitle,
                style: UIAlertActionStyle.Cancel) { _ in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            presenter.presentViewController(alertController, animated: true, completion: nil)
    }
    
}