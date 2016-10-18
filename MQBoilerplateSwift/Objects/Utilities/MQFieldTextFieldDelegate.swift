//
//  MQFieldTextFieldDelegate.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/20/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQFieldTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let fieldTextField = textField as? MQFieldTextField {
            if let field = fieldTextField.field {
                if let invalidCharacterSet = field.invalidCharacterSet {
                    if string.hasCharactersFromSet(invalidCharacterSet) {
                        return false
                    }
                }
                
                if let mutableText = textField.text!.mutableCopy() as? NSMutableString {
                    mutableText.replaceCharacters(in: range, with: string)
                    field.value = mutableText
                }
            }
        }
        
        return true
    }
    
}
