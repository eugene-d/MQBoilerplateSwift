//
//  MQCommand.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/15/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQCommand {
    
    /**
    Defines the main task of this command and called when execute() is called.
    If supplied, calling execute() WILL NOT call the process() function.
    This property is provided for cases when you don't want to subclass MQCommand.
    */
    public var processBlock: (() -> Void)?
    
    /**
    Tasks that need to be executed after the process regardless of whether
    the command succeeds or fails. This block is called before either the successBlock
    or the failureBlock.
    
    Examples of what to do in a completion block are closing input/output streams,
    or hiding a screen's "Loading" view before either showing the results or an error message.
    */
    public var completionBlock: (() -> Void)?
    
    /**
    Executed when no errors occur, with or without a result.
    This is performed after the completionBlock.
    */
    public var successBlock: ((AnyObject?) -> Void)?
    
    /**
    Executed when an error occurs during processing.
    */
    public var failureBlock: ((NSError) -> Void)?
    
    /**
    The result returned to the success block.
    */
    public var result: AnyObject?
    
    /**
    The error returned to the failure block. Setting a non-nil error automatically
    makes the command a failure and executes the failure block.
    */
    public var error: NSError?
    
    /**
    The view controller that presents the `UIAlertController` if the `failureBlock`
    has been set to display an error dialog upon failure. This behavior can be set
    by calling `showErrorDialogOnFail()`.
    */
    public var errorPresenter: UIViewController?
    
    /**
    The title for the error dialog.
    */
    public var errorDialogTitle: String?
    
    /**
    The title for the error dialog's OK button.
    */
    public var okButtonTitle: String?
    
    public init() {}
    
    public func process() {}
    
    public func execute() {
        // If a processBlock has been supplied, execute that.
        // Otherwise, execute the overridden process() function.
        if let processBlock = self.processBlock {
            processBlock()
        } else {
            self.process()
        }
        
        // Perform the completionBlock if supplied.
        if let completionBlock = self.completionBlock {
            completionBlock()
        }
        
        // Depending on whether an error occurred or not, execute either the
        // failure block or the success block.
        if let error = self.error {
            if let failureBlock = self.failureBlock {
                failureBlock(error)
            }
        } else {
            if let successBlock = self.successBlock {
                successBlock(self.result)
            }
        }
    }
    
    /**
    Executes the failure block with the given error.
    */
    public func failWithError(error: NSError) {
        self.error = error
        if let failureBlock = self.failureBlock {
            failureBlock(error)
        }
    }
    
    /**
    Overrides the `failureBlock` to show a `UIAlertController` when an error occurs. The error
    dialog uses default titles and button titles.
    */
    public func showErrorDialogInFailureBlock(presenter: UIViewController) {
        self.showErrorDialogInFailureBlock(presenter, errorDialogTitle: "Error", okButtonTitle: "OK")
    }
    
    /**
    Overrides the `failureBlock` to show a `UIAlertController` when an error occurs.
    */
    public func showErrorDialogInFailureBlock(presenter: UIViewController, errorDialogTitle: String, okButtonTitle: String) {
        // Keep a reference to the values.
        self.errorPresenter = presenter
        self.errorDialogTitle = errorDialogTitle
        self.okButtonTitle = okButtonTitle
        
        let customFailureBlock = self.failureBlock
        self.failureBlock = {[unowned self] error in
            // If the developer provided a `failureBlock`, execute that first.
            if let theCustomFailureBlock = customFailureBlock {
                theCustomFailureBlock(error)
            }
            
            // Display an alert view that shows the error.
            let alertController = UIAlertController(title: self.errorDialogTitle!, message: error.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: self.okButtonTitle!, style: .Default, handler: {(action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(okAction)
            self.errorPresenter!.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}