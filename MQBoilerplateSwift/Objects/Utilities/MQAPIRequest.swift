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
public class MQAPIRequest {
    
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
    
    public var finishBlock: (() -> Void)?
    public var failureBlock: ((NSError) -> Void)?
    public var builderBlock: ((AnyObject?) -> (AnyObject?, NSError?)?)?
    public var successBlock: ((AnyObject?) -> Void)?
    public var cookieBlock: ((NSHTTPCookie) -> Void)?
    
    public init(session: NSURLSession, method: MQAPIRequest.Method, URL: String, parameters: [String : AnyObject]?) {
        self.session = session
        self.method = method
        self.URL = NSURL(string: URL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)!
        self.parameters = parameters
        self.needsAuthentication = false
    }
    
    public func start() {
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
        
        if let startBlock = self.startBlock {
            startBlock()
        }
        
        self.task!.resume()
    }
    
    public func resume() {
        if let task = self.task {
            task.resume()
        } else {
            self.start()
        }
    }
    
    public func cancel() {
        if let task = self.task {
            task.cancel()
        }
    }
    
    public func suspend() {
        if let task = self.task {
            task.suspend()
        }
    }
    
    public func finish() {
        if let finishBlock = self.finishBlock {
            MQDispatcher.executeInMainThread {
                finishBlock()
            }
        }
    }
    
    public func failWithError(error: NSError) {
        if let failureBlock = self.failureBlock {
            MQDispatcher.executeInMainThread {
                failureBlock(error)
            }
        }
    }
    
    public func succeedWithResult(result: AnyObject?) {
        if let successBlock = self.successBlock {
            MQDispatcher.executeInMainThread {
                successBlock(result)
            }
        }
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
    
}
