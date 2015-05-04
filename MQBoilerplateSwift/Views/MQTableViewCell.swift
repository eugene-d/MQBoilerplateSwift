//
//  MQTableViewCell.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/4/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public class MQTableViewCell: UITableViewCell {
    
    public func applyConstantColors() {
        
    }
    
    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.applyConstantColors()
    }
    
    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.applyConstantColors()
    }
    
}
