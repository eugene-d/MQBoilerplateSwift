//
//  MQErrorDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/25/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public final class MQErrorDialog {
    
    public class func showError(error: ErrorType, inPresenter presenter: UIViewController) {
        // If the error is a custom error, use the customized localized description.
        // If not, get the associated NSError and use its localized description.
        let message: String
        if let error = error as? MQError {
            message = error.localizedDescription
        } else {
            message = error.toObject().localizedDescription
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .Default) {_ in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okButtonAction)
        
        presenter.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
