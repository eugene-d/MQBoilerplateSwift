//
//  MQFieldTextField.swift
//  CheersOAPE
//
//  Created by Matt Quiros on 4/18/15.
//  Copyright (c) 2015 Silicon Valley Insight. All rights reserved.
//

import UIKit

open class MQFieldTextField : UITextField {
    
    open weak var field: MQField? {
        didSet {
            if let field = self.field {
                self.applyTextInputTraits()
                if let value = field.value as? String {
                    self.text = value
                    return
                }
            }
            self.text = nil
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clearButtonMode = .whileEditing
        self.keyboardType = .default
    }
    
    func applyTextInputTraits() {
        if let field = self.field {
            if let keyboardType = field.keyboardType {
                self.keyboardType = keyboardType
            }
            
            if let autocapitalizationType = field.autocapitalizationType {
                self.autocapitalizationType = autocapitalizationType
            }
        }
    }
    
}
