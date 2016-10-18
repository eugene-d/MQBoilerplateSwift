//
//  MQConfirmDialog.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/8/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQConfirmDialog {
    
    @available(*, deprecated: 1.10)
    open var title: String
    
    @available(*, deprecated: 1.10)
    open var message: String
    
    @available(*, deprecated: 1.10)
    open var confirmButtonTitle: String
    
    @available(*, deprecated: 1.10)
    open var cancelButtonTitle: String
    
    @available(*, deprecated: 1.10)
    public init() {
        self.title = "Confirm"
        self.message = "Are you sure?"
        self.confirmButtonTitle = "Yes"
        self.cancelButtonTitle = "Cancel"
    }
    
    @available(*, deprecated: 1.10)
    open func showInPresenter(_ presenter: UIViewController, confirmAction someAction: (() -> Void)?) {
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        
        let confirmButtonAction = UIAlertAction(title: self.confirmButtonTitle,
            style: .default) {_ in
                if let confirmAction = someAction {
                    confirmAction()
                }
                alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(confirmButtonAction)
        
        let cancelAction = UIAlertAction(title: self.cancelButtonTitle,
            style: UIAlertActionStyle.cancel) {_ in
                alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    open class func showInPresenter(_ presenter: UIViewController,
        title: String = "Confirm",
        message: String = "Are you sure?",
        confirmButtonTitle: String = "Yes",
        cancelButtonTitle: String = "Cancel",
        confirmAction someAction: (() -> ())?) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let confirmButtonAction = UIAlertAction(title: confirmButtonTitle,
                style: .default) { _ in
                    if let confirmAction = someAction {
                        confirmAction()
                    }
                    alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(confirmButtonAction)
            
            let cancelAction = UIAlertAction(title: cancelButtonTitle,
                style: UIAlertActionStyle.cancel) { _ in
                    alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            presenter.present(alertController, animated: true, completion: nil)
    }
    
}
