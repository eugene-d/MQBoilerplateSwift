//
//  MQFieldTextFieldCell.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 20/01/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

/**
 A `UITableViewCell` with a label on the left and a `UITextField` on the right, for modifying
 the value of an `MQField`.
 */
public class MQFieldTextFieldCell: MQFieldCell {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: MQFieldTextField!
    
    public override var field: MQField? {
        didSet {
            defer {
                self.setNeedsLayout()
            }
            guard let field = self.field else {
                self.nameLabel.text = nil
                self.textField.text = nil
                return
            }
            self.nameLabel.text = field.label
            self.textField.text = field.value as? String
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.wrapperView.backgroundColor = UIColor.clearColor()
        
        self.textField.borderStyle = .None
        self.textField.textAlignment = .Right
        self.textField.clearButtonMode = .WhileEditing
        
        self.selectionStyle = .None
    }
    
}
