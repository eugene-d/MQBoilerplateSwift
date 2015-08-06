//
//  MQRetryView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/27/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

public protocol MQRetryViewDelegate {
    
    func retryViewDidTapRetry(retryView: MQRetryView)
    
}

public class MQRetryView: UIView {
    
    // FIXME: Swift 2.0
//    public var error: ErrorType?
    public var error: NSError?
    public var delegate: MQRetryViewDelegate?
    
}
