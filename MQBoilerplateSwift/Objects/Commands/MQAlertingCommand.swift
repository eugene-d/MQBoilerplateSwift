//
//  MQAlertingCommand.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
An MQAlertingCommand is an MQCommand that automatically displays an alert dialog
if it fails. You need to supply a UIViewController as errorPresenter so that
the command knows where to present the dialog from.
*/
public class MQAlertingCommand: MQCommand {
    
    public let errorPresenter: UIViewController
    
    public var errorDialogTitle: String
    public var okButtonTitle: String
    
    public init(errorPresenter: UIViewController) {
        self.errorPresenter = errorPresenter
        self.errorDialogTitle = "Error"
        self.okButtonTitle = "OK"
        
        super.init()
        
        // Define the failureBlock that presents the alert dialog.
        self.failureBlock = {[unowned self] error in
            // Display an alert view that shows the error.
            let alertController = UIAlertController(title: self.errorDialogTitle, message: error.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: self.okButtonTitle, style: .Default, handler: {(action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(okAction)
            self.errorPresenter.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}