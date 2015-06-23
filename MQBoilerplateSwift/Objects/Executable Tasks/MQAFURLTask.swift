//
//  MQAFURLTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation
import Alamofire

public class MQAFURLTask: MQExecutableTask {
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    public var manager: Alamofire.Manager
    var method: Alamofire.Method
    public var URL: String
    var parameters: [String : AnyObject]?
    var parameterEncoding: Alamofire.ParameterEncoding
    
    public init(manager: Alamofire.Manager, method: Alamofire.Method, URL: String, parameters: [String : AnyObject]?, parameterEncoding: Alamofire.ParameterEncoding) {
        self.manager = manager
        self.method = method
        self.URL = URL
        self.parameters = parameters
        self.parameterEncoding = parameterEncoding
    }
    
    public func execute() {
        self.performSequence()
    }
    
    public func performSequence() {
        
    }
    
    public func computeResult() {
        
    }
    
    public func handleResponse(someRequest: NSURLRequest?, _ someResponse: NSURLResponse?, _ someObject: AnyObject?, _ someError: NSError?) {
        
    }
    
    public func buildResult(object: Any?) -> Any? {
        return nil
    }
    
}