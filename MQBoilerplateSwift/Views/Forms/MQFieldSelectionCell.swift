//
//  MQFieldSelectionCell.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 20/01/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

public class MQFieldSelectionCell: MQFieldCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value2, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

