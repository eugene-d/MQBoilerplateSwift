//
//  MQConfirmDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/8/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQConfirmDialog {
    
    public var title: String
    public var message: String
    public var confirmButtonTitle: String
    public var cancelButtonTitle: String
    
    public init() {
        self.title = "Confirm"
        self.message = "Are you sure?"
        self.confirmButtonTitle = "Yes"
        self.cancelButtonTitle = "Cancel"
    }
    
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
    
}