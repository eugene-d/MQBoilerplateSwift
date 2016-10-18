//
//  MQErrorDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/25/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQErrorDialog {
    
    open var error: NSError
    
    public init(error: NSError) {
        self.error = error
    }
    
    open func showInPresenter(_ errorPresenter: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: self.error.localizedDescription, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "OK", style: .default) {_ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okButtonAction)
        
        errorPresenter.present(alertController, animated: true, completion: nil)
    }
    
}
