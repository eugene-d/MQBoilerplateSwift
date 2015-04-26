//
//  MQHTTPOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/26/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

/**
The main difference between an MQHTTPOperation and an MQOperation
is that the `main()` method simply executes the `process()` method.
Calling the success and failure blocks is left to the developer.
*/
public class MQHTTPOperation: MQOperation {
    
    public override func main() {
        self.process()
    }
    
}
