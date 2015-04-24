//
//  MQOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/23/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
EXPERIMENTAL CLASS

An `MQOperation` is defined as a synchronous operation and should only be executed
by adding it to an `NSOperationQueue`.
*/
public class MQOperation : NSOperation {
    
    /**
    Tasks that need to be executed after the process block finishes, but before
    either the success of failure block is executed. An example of what to do in
    a `preparationBlock` is to hide a screen's "Loading" view before either showing
    the results or an error message.
    */
    public var preparationBlock: (Void -> Void)?
    
    /**
    Executed after the `preparationBlock` if `error` is `nil`.
    You must take care of dispatching UI-related tasks in the `successBlock` to the
    main thread.
    */
    public var successBlock: ((AnyObject?) -> Void)?
    
    /**
    Executed after the `preparationBlock` if the `error` is non-`nil`.
    You must take care of dispatching UI-related tasks in the `failureBlock` to the
    main thread.
    */
    public var failureBlock: ((NSError) -> Void)?
    
    /**
    The error that was produced during the process block. If this property is `nil`,
    the operation is considered successful and the `successBlock` is executed.
    Otherwise, the `failureBlock` is executed.
    */
    public var error: NSError?
    
    /**
    The value that will be returned to the `successBlock` when it is executed.
    */
    public var result: AnyObject?
    
    public var errorPresenter: UIViewController?
    public var errorDialogTitle: String?
    public var errorDialogOKButtonTitle: String?
    
    public override func main() {
        self.process()
        
        if self.cancelled {
            return
        }
        
        if let preparationBlock = self.preparationBlock {
            preparationBlock()
        }
        
        if self.cancelled {
            return
        }
        
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
    Defines the main process of this operation. Assign a value to the `error`
    property to mark the operation as failed.
    
    You must constantly check for the operation's `cancelled` property when
    overriding this method.
    */
    public func process() {
        
    }
    
    public func showErrorDialogOnFail(#errorPresenter: UIViewController) {
        self.showErrorDialogOnFail(errorPresenter: errorPresenter, errorDialogTitle: "Error", errorDialogOKButtonTitle: "OK")
    }
    
    public func showErrorDialogOnFail(#errorPresenter: UIViewController,
        errorDialogTitle: String,
        errorDialogOKButtonTitle: String) {
            
        // Keep a reference to the values.
        self.errorPresenter = errorPresenter
        self.errorDialogTitle = errorDialogTitle
        self.errorDialogOKButtonTitle = errorDialogOKButtonTitle
        
        let customFailureBlock = self.failureBlock
        self.failureBlock = {[unowned self] error in
            // If the developer provided a `failureBlock`, execute that first.
            if let theCustomFailureBlock = customFailureBlock {
                theCustomFailureBlock(error)
            }
            
            // Display an alert view that shows the error.
            let alertController = UIAlertController(title: self.errorDialogTitle!, message: error.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: self.errorDialogOKButtonTitle!, style: .Default, handler: {(action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(okAction)
            
            // Show the error dialog in the main UI thread.
            dispatch_async(dispatch_get_main_queue(), {[unowned self] in
                self.errorPresenter!.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
}