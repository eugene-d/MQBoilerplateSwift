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
open class MQAPIRequest: MQExecutableTask, Equatable {
    
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
    
    open var type: MQExecutableTaskType {
        return .default
    }
    
    open let session: URLSession
    open var task: URLSessionTask?
    
    open let URL: Foundation.URL
    open let method: MQAPIRequest.Method
    open let parameters: [String : AnyObject]?
    
    open var needsAuthentication: Bool
    open var cookie: HTTPCookie?
    
    open var startBlock: (() -> Void)?
    
    /**
    The block executed when the request returns with a response.
    
    **IMPORTANT:** Remember to execute the `finishBlock`, the `failureBlock`, and the `successBlock`
    in the main thread. The convenience methods `finish()`, `failWithError(:)`, and `succeedWithResult(:)`
    are provided for performing the said blocks in the main thread.
    */
    open var responseHandler: ((Data?, URLResponse?, NSError?) -> Void)?
    
    open var returnBlock: (() -> Void)?
    open var failureBlock: ((NSError) -> Void)?
    open var builderBlock: ((AnyObject?) -> (AnyObject?, NSError?)?)?
    open var successBlock: ((Any?) -> Void)?
    open var cookieBlock: ((HTTPCookie) -> Void)?
    open var finishBlock: (() -> Void)?
    
    public init(session: URLSession, method: MQAPIRequest.Method, URL: String, parameters: [String : AnyObject]?) {
        self.session = session
        self.method = method
        self.URL = Foundation.URL(string: URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!
        self.parameters = parameters
        self.needsAuthentication = false
    }
    
    open func begin() {
        let request = NSMutableURLRequest(url: self.URL)
        request.httpMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if self.needsAuthentication {
            if let cookie = self.cookie {
//                if let value = cookie.value {
//                    request.setValue("\(cookie.name)=\(value)", forHTTPHeaderField: "Cookie")
//                }
                request.setValue("\(cookie.name)=\(cookie.value)", forHTTPHeaderField: "Cookie")
            }
        }
        
        if let parameters = self.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch _ {
                request.httpBody = nil
            }
        }

        self.task = self.session.dataTask(with: request as URLRequest, completionHandler: {[unowned self] (data, response, error) in
            if let responseHandler = self.responseHandler {
                responseHandler(data, response, error as NSError?)
            }
        }) 
        
        self.runStartBlock()
        self.task!.resume()
    }
    
    /**
    Meaningless to MQAPIRequest--only here for protocol compliance.
    */
    public final func mainProcess() {
        
    }
    
    open func runStartBlock() {
        MQExecutableTaskBlockRunner.runStartBlockOfTask(self)
    }
    
    open func runReturnBlock() {
        MQExecutableTaskBlockRunner.runReturnBlockOfTask(self)
    }
    
    open func runSuccessBlockAndFinish(result: Any?) {
        MQExecutableTaskBlockRunner.runSuccessBlockOfTaskAndFinish(self, withResult: result)
    }
    
    open func runFailureBlockAndFinish(error: NSError) {
        MQExecutableTaskBlockRunner.runFailureBlockOfTaskAndFinish(self, withError: error)
    }
    
    open func runFinishBlock() {
        MQExecutableTaskBlockRunner.runFinishBlockOfTask(self)
    }
    
    open func overrideFailureBlockToShowErrorDialogInPresenter(_ presenter: UIViewController) {
        MQExecutableTaskBlockRunner.overrideFailureBlockOfTask(self, toShowErrorDialogInPresenter: presenter)
    }
    
}

extension MQAPIRequest: Hashable {
    
    public var hashValue: Int {
        return Unmanaged.passUnretained(self).toOpaque().hashValue
    }
    
}

public func ==(r1: MQAPIRequest, r2: MQAPIRequest) -> Bool {
    return r1.hashValue == r2.hashValue
}
