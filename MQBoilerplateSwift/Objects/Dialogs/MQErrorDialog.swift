//
//  MQErrorDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/25/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public final class MQErrorDialog {
    
    public class func showError(error: NSError, inPresenter presenter: UIViewController) {
        var message: String
        if let customError = error as? MQError {
            message = customError.localizedDescription
        } else {
            message = error.localizedDescription
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .Default) {_ in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okButtonAction)
        
        presenter.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
