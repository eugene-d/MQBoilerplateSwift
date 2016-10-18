//
//  MQRetryView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/27/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public protocol MQRetryViewDelegate {
    
    func retryViewDidTapRetry(_ retryView: MQRetryView)
    
}

open class MQRetryView: UIView {
    
    open var error: NSError?
    open var delegate: MQRetryViewDelegate?
    
}
