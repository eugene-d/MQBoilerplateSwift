//
//  MQAFURLDataTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQAFURLDataTask: MQAFURLTask {
    
    public override func performSequence() {
        self.runStartBlock()
        
        self.manager
            .request(self.method, self.URL, parameters: self.parameters, encoding: self.parameterEncoding)
            .response {[unowned self] (someRequest, someResponse, someObject, someError) in
            self.handleResponse(someRequest, someResponse, someObject, someError)
        }
    }
    
}