//
//  MQURLTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQURLTask: MQExecutableTask, Equatable {
    
    public enum Method: String {
        case OPTIONS = "OPTIONS"
        case GET = "GET"
        case HEAD = "HEAD"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"
    }
    
    public var type: MQExecutableTaskType {
        return .Default
    }
    
    public let session: NSURLSession
    public var task: NSURLSessionTask?
    
    public let URL: NSURL
    public let method: MQAPIRequest.Method
    public let parameters: [String : AnyObject]?
    
    public var needsAuthentication: Bool
    public var cookie: NSHTTPCookie?
    
    public var startBlock: (() -> Void)?
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var cookieBlock: ((NSHTTPCookie) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public var result: Any?
    public var error: NSError?
    
    public init(session: NSURLSession, method: MQAPIRequest.Method, URL: String, parameters: [String : AnyObject]?) {
        self.session = session
        self.method = method
        self.URL = NSURL(string: URL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)!
        self.parameters = parameters
        self.needsAuthentication = false
    }
    
    public func execute() {
        
    }
    
    public func performSequence() {
        
    }
    
    public func computeResult() {
        
    }
    
}

extension MQURLTask: Hashable {
    
    public var hashValue: Int {
        return unsafeAddressOf(self).hashValue
    }
    
}

public func ==(r1: MQURLTask, r2: MQURLTask) -> Bool {
    return r1.hashValue == r2.hashValue
}
