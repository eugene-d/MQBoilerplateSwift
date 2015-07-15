//
//  MQAFURLTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation
import Alamofire

public class MQAFURLTask: MQExecutableTask, Equatable {
    
    public enum MQAFURLTaskType {
        case Data, Upload(NSData), Download
    }
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    public var manager: Alamofire.Manager
    public var taskType: MQAFURLTaskType
    public var method: Alamofire.Method
    public var URL: String
    public var parameters: [String : AnyObject]?
    public var parameterEncoding: Alamofire.ParameterEncoding
    
    public init(manager: Alamofire.Manager,
        taskType: MQAFURLTaskType,
        method: Alamofire.Method,
        URL: String,
        parameters: [String : AnyObject]?,
        parameterEncoding: Alamofire.ParameterEncoding) {
            self.manager = manager
            self.taskType = taskType
            self.method = method
            self.URL = URL
            self.parameters = parameters
            self.parameterEncoding = parameterEncoding
    }
    
    /**
    Override point for customizing the `NSURLRequest` object used by Alamofire to make
    the request. Currently used to set custom HTTP header fields, such as cookies.
    */
    public func customizeURLRequest() -> NSURLRequest? {
        return nil
    }
    
    public func execute() {
        self.performSequence()
    }
    
    public func performSequence() {
        // Run the start block.
        self.runStartBlock()
        
        // Execute the proper Alamofire function depending on
        // the type of the URL task.
        switch self.taskType {
        case .Data:
            if let request = self.customizeURLRequest() {
                self.manager
                    .request(request)
                    .response {[unowned self] (someRequest, someResponse, someObject, someError) in
                        self.handleResponse(someRequest, someResponse, someObject, someError)
                }
            } else {
                self.manager
                    .request(self.method, self.URL, parameters: self.parameters, encoding: self.parameterEncoding)
                    .response {[unowned self] (someRequest, someResponse, someObject, someError) in
                        self.handleResponse(someRequest, someResponse, someObject, someError)
                }
            }
            
        case .Upload(let data):
            if let request = self.customizeURLRequest() {
                self.manager
                    .upload(request, data: data)
                    .response {[unowned self] (someRequest, someResponse, someObject, someError) in
                        self.handleResponse(someRequest, someResponse, someObject, someError)
                }
            } else {
                self.manager
                    .upload(self.method, self.URL, data: data)
                    .response {[unowned self] (someRequest, someResponse, someObject, someError) in
                        self.handleResponse(someRequest, someResponse, someObject, someError)
                }
            }
            
        case .Download:
            // empty
            break
        }
    }
    
    public func computeResult() {
        
    }
    
    public func handleResponse(someRequest: NSURLRequest?, _ someResponse: NSURLResponse?, _ someObject: AnyObject?, _ someError: NSError?) {
        
    }
    
    public func buildResult(object: Any?) throws -> Any? {
        return nil
    }
    
}

extension MQAFURLTask: Hashable {
    
    public var hashValue: Int {
        return unsafeAddressOf(self).hashValue
    }
    
}

public func ==(r1: MQAFURLTask, r2: MQAFURLTask) -> Bool {
    return r1.hashValue == r2.hashValue
}
