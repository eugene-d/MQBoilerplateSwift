//
//  MQFieldTextFieldDelegate.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/20/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQFieldTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let fieldTextField = textField as? MQFieldTextField {
            if let field = fieldTextField.field,
                let invalidCharacterSet = field.invalidCharacterSet {
                    if string.hasCharactersFromSet(invalidCharacterSet) {
                        return false
                    }
                    
                    if let mutableText = textField.text.mutableCopy() as? NSMutableString {
                        mutableText.replaceCharactersInRange(range, withString: string)
                        field.value = mutableText
                    }
            }
        }
        
        return true
    }
    
}