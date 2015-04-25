//
//  MQErrorDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/25/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQErrorDialog {
    
    public var error: NSError
    
    public init(error: NSError) {
        self.error = error
    }
    
    public func showInPresenter(errorPresenter: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: self.error.localizedDescription, preferredStyle: .Alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .Default) {[unowned self] action in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okButtonAction)
        
        errorPresenter.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
