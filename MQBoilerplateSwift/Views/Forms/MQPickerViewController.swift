//
//  MQPickerViewController.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 21/01/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

public protocol MQPickerViewControllerDelegate {
    
    func pickerViewController(viewController: MQPickerViewController, didPickValue value: Any?, atIndex: Int?)
    
}

public class MQPickerViewController: UIViewController {
    
    var overlayView: UIView
    var toolbar: UIToolbar
    var pickerView: UIPickerView
    
    var possibleValues: [String]
    var selectedRow: Int
    
    public var delegate: MQPickerViewControllerDelegate?
    
    /**
     If `true`, a 'Select' option will be the first item in the list of possible values,
     choosing which sets the `value` of the field to `nil`.
     */
    public let clearable: Bool
    
    public init(possibleValues: [String], clearable: Bool, initialSelectedIndex: Int?) {
        self.overlayView = UIView()
        self.toolbar = UIToolbar()
        self.pickerView = UIPickerView()
        
        self.possibleValues = possibleValues
        self.clearable = clearable
        self.selectedRow = initialSelectedIndex ?? possibleValues.count / 2
        
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.clearColor()
        
        self.toolbar.translucent = false
        self.toolbar.barTintColor = UIColor.whiteColor()
        
        self.pickerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        self.view.addSubviews(self.overlayView, self.toolbar, self.pickerView)
        self.addAutolayout()
    }
    
    func addAutolayout() {
        UIView.disableAutoresizingMasksInViews(self.overlayView, self.toolbar, self.pickerView)
        
        let rules = ["H:|-0-[overlayView]-0-|",
            "H:|-0-[toolbar]-0-|",
            "H:|-0-[pickerView]-0-|",
            "V:|-0-[overlayView]-0-|",
            "V:[toolbar(44)]-0-[pickerView(162)]-0-|"]
        
        let views = ["overlayView" : self.overlayView,
            "toolbar" : self.toolbar,
            "pickerView" : self.pickerView]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormatArray(rules,
            metrics: nil,
            views: views))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelButtonTapped"))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneButtonTapped"))
        self.toolbar.items = [cancelButton, doneButton]
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.selectRow(self.selectedRow, inComponent: 0, animated: false)
    }
    
    func cancelButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonTapped() {
        if let delegate = self.delegate {
            let selectedIndex: Int? = {
                if self.clearable {
                    if self.selectedRow == 0 {
                        return nil
                    } else {
                        return self.selectedRow - 1
                    }
                }
                return self.selectedRow
            }()
            
            let selectedValue: String? = {
                if let selectedIndex = selectedIndex {
                    return self.possibleValues[selectedIndex]
                }
                return nil
            }()
            
            delegate.pickerViewController(self, didPickValue: selectedValue, atIndex: selectedIndex)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension MQPickerViewController: UIPickerViewDataSource {
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.possibleValues.count
    }
    
}

extension MQPickerViewController: UIPickerViewDelegate {
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.clearable {
            if row == 0 {
                return "Select..."
            } else {
                return self.possibleValues[row - 1]
            }
        }
        return self.possibleValues[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
}
