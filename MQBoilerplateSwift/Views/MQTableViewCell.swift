//
//  MQTableViewCell.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 5/4/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

open class MQTableViewCell: UITableViewCell {
    
    open func applyConstantColors() {
        
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.applyConstantColors()
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.applyConstantColors()
    }
    
}
