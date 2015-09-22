//
//  MQURLOperation.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

/**
A base implementation for an operation that makes URL requests.
*/
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
    
    public enum ContentType {
        /**
        Sets the `Content-Type` HTTP header to `application/json`.
        */
        case JSON
        
        /**
        Sets the `Content-Type` HTTP header to `multipart/form-data; boundary=` plus
        the value of the `formDataBoundary` property. You must therefore set the `formDataBoundary`
        property if you choose this content type.
        */
        case MultipartFormData
    }
    
    /**
    The `NSURLSession` object which creates the URL tasks. Ideally, you create subclasses of
    `MQURLOperation` that share a singleton `NSURLSession` object, and you simply pass the singleton
    to the `MQURLOperation` initializer.
    */
    public var session: NSURLSession
    public var method: MQURLOperation.Method
    public var URL: String
    
    /**
    The `Content-Type` HTTP header field.
    */
    public var contentType: ContentType
    
    public var parameters: [String : AnyObject]?
    
    /**
    The boundary string for multipart form data requests.
    */
    public var formDataBoundary: String!
    
    private var task: NSURLSessionDataTask!
    
    // MARK -
    
    public init(session: NSURLSession,
        method: MQURLOperation.Method,
        URL: String,
        contentType: ContentType,
        parameters: [String : AnyObject]? = nil) {
            self.session = session
            self.method = method
            self.URL = URL
            self.contentType = contentType
            self.parameters = parameters
    }
    
    /**
    Builds the URL request object on which the URL task will be based. To set your own HTTP headers,
    override this function and edit the request object returned by the `super` implementation.
    */
    public func createRequest() -> NSMutableURLRequest {
        let URLString = self.URL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        request.HTTPMethod = self.method.rawValue
        
        switch self.contentType {
        case .JSON:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // FIXME: Swift 2.0
            if let parameters = self.parameters {
                var error: NSError?
                let HTTPBody: NSData?
                do {
                    HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
                } catch let error1 as NSError {
                    error = error1
                    HTTPBody = nil
                }
                if let error = error {
                    fatalError("Cannot encode JSON parameters: \(error)")
                } else {
                    request.HTTPBody = HTTPBody
                }
            }
//            do {
//                if let parameters = self.parameters {
//                    let HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//                    request.HTTPBody = HTTPBody
//                }
//            } catch {
//                fatalError("Cannot encode JSON parameters")
//            }
            
        case .MultipartFormData:
            // FIXME: Swift 2.0
            if let boundary = self.formDataBoundary {
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = self.createMultipartFormData()
            } else {
                fatalError("Initialised a multipart form data request without specifying formDataBoundary")
            }
//            guard let boundary = self.formDataBoundary else {
//                fatalError("Initialised a multipart form data request without specifying formDataBoundary")
//            }
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            request.HTTPBody = self.createMultipartFormData()
        }
        
        return request
    }
    
    /**
    Override point for building the HTTP body of a multipart form data request.
    If you set the `contentType` to `.MultipartFormData`, you must override this function.
    */
    public func createMultipartFormData() -> NSMutableData {
        fatalError("Did not override: \(__FUNCTION__)")
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
        
        let request = self.createRequest()
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
            // FIXME: Swift 2.0
//            defer {
//                self.closeOperation()
//            }
            self.closeOperation()
    }
    
}