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
    
    /**
    The block executed when the request returns with a response.
    
    **IMPORTANT:** Remember to execute the `finishBlock`, the `failureBlock`, and the `successBlock`
    in the main thread. The convenience methods `finish()`, `failWithError(:)`, and `succeedWithResult(:)`
    are provided for performing the said blocks in the main thread.
    */
    public var responseHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?
    
    public var returnBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var builderBlock: ((AnyObject?) -> (AnyObject?, NSError?)?)?
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
    
    public func begin() {
        let request = NSMutableURLRequest(URL: self.URL)
        request.HTTPMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if self.needsAuthentication {
            if let cookie = self.cookie {
                if let value = cookie.value {
                    request.setValue("\(cookie.name)=\(value)", forHTTPHeaderField: "Cookie")
                }
            }
        }
        
        if let parameters = self.parameters {
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: .allZeros, error: nil)
        }
        
        self.task = self.session.dataTaskWithRequest(request) {[unowned self] (data, response, error) in
            if let responseHandler = self.responseHandler {
                responseHandler(data, response, error)
            }
        }
        
        self.performStart()
        self.task!.resume()
    }
    
    /**
    Meaningless to MQAPIRequest--only here for protocol compliance.
    */
    public final func mainProcess() {
        
    }
    
    public func showErrorDialogOnFail(presenter: UIViewController) {
        let someCustomFailureBlock = self.failureBlock
        self.failureBlock = {[unowned self] error in
            if let customFailureBlock = someCustomFailureBlock {
                customFailureBlock(error)
            }
            
            MQErrorDialog(error: error).showInPresenter(presenter)
        }
    }
    
    public func performStart() {
        if let startBlock = self.startBlock {
            MQDispatcher.syncRunInMainThread {
                startBlock()
            }
        }
    }
    
    public func performReturn() {
        if let returnBlock = self.returnBlock {
            MQDispatcher.syncRunInMainThread {
                returnBlock()
            }
        }
    }
    
    public func performSuccessWithResult(result: Any?) {
        if let successBlock = self.successBlock {
            MQDispatcher.syncRunInMainThread {
                successBlock(result)
                
                if let finishBlock = self.finishBlock {
                    finishBlock()
                }
            }
        }
    }
    
    public func performFailureWithError(error: NSError) {
        if let failureBlock = self.failureBlock {
            MQDispatcher.syncRunInMainThread {
                failureBlock(error)
                
                if let finishBlock = self.finishBlock {
                    finishBlock()
                }
            }
        }
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
