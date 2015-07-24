//
//  MQURLOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQURLOperation: MQAsynchronousOperation {
    
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
    
    public var session: NSURLSession
    public var method: MQURLOperation.Method
    public var URL: String
    public var parameters: [String : AnyObject]?
    
    private var task: NSURLSessionDataTask!
    
    // MARK -
    
    public init(session: NSURLSession, method: MQURLOperation.Method, URL: String, parameters: [String : AnyObject]?) {
        self.session = session
        self.method = method
        self.URL = URL
        self.parameters = parameters
    }
    
    public func buildRequest() -> NSURLRequest {
        let request = NSURLRequest(URL: NSURL(string: self.URL)!)
        return request
    }
    
    public override func main() {
        if self.cancelled {
            self.closeOperation()
            return
        }
        
        self.runStartBlock()
        
        if self.cancelled {
            self.closeOperation()
            return
        }
        
        let request = self.buildRequest()
        self.task = self.session.dataTaskWithRequest(request) {[unowned self] (data, response, error) in
            self.handleResponse(response, data, error)
        }
        self.task.resume()
    }
    
    /**
    Handles the response returned by the server. You should override this method in a base
    `MQURLOperation` class so that all its children have a uniform behavior of processing an API's response.
    
    **IMPORTANT** You must call `super.handleResponse()` at the very end of your override to 
    make sure that the `NSOperation` state flags are correctly updated.
    */
    public func handleResponse(someResponse: NSURLResponse?,
        _ someData: NSData?,
        _ someError: NSError?) {
            defer {
                self.closeOperation()
            }
    }
    
}