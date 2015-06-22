//
//  MQAPIRequest.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/30/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
NOTE: This class is a work in progress and currently sets a blueprint for `NSURLSessionDataTask` objects only.
Moreover, HTTP payloads are assumed to be written in JSON format.
*/
public class MQAPIRequest: MQExecutableTask, Equatable {
    
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
    
    public var result: Any?
    public var error: NSError?
    
    /**
    The block executed when the request returns with a response.
    
    **IMPORTANT:** Remember to execute the `finishBlock`, the `failureBlock`, and the `successBlock`
    in the main thread. The convenience methods `finish()`, `failWithError(:)`, and `succeedWithResult(:)`
    are provided for performing the said blocks in the main thread.
    */
    public var responseHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?
    
    public var builderBlock: ((Any) throws -> (Any))?
    
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var successBlock: ((Any?) -> Void)?
    public var cookieBlock: ((NSHTTPCookie) -> Void)?
    public var finishBlock: (() -> Void)?
    
    public init(session: NSURLSession, method: MQAPIRequest.Method, URL: String, parameters: [String : AnyObject]?) {
        self.session = session
        self.method = method
        self.URL = NSURL(string: URL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)!
        self.parameters = parameters
        self.needsAuthentication = false
    }
    
    public func execute() {
        let request = NSMutableURLRequest(URL: self.URL)
        request.HTTPMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if self.needsAuthentication {
            if let cookie = self.cookie {
                request.setValue("\(cookie.name)=\(cookie.value)", forHTTPHeaderField: "Cookie")
            }
        }
        
        if let parameters = self.parameters {
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            } catch _ {
                request.HTTPBody = nil
            }
        }
        
        self.task = self.session.dataTaskWithRequest(request) {[unowned self] (someData, someResponse, someError) in
            self.handleResponse(someData, someResponse: someResponse, someError: someError)
        }
        
        self.runStartBlock()
        self.task!.resume()
    }
    
    public func performSequence() {
        
    }
    
    public func computeResult() {
        
    }
    
    public func handleResponse(someData: NSData?, someResponse: NSURLResponse?, someError: NSError?) {
        
    }
    
}

extension MQAPIRequest: Hashable {
    
    public var hashValue: Int {
        return unsafeAddressOf(self).hashValue
    }
    
}

public func ==(r1: MQAPIRequest, r2: MQAPIRequest) -> Bool {
    return r1.hashValue == r2.hashValue
}
