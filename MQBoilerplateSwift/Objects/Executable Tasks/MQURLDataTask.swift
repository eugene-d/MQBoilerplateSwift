//
//  MQURLDataTask.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 6/23/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation


public class MQURLDataTask: MQURLTask {
    
    public var builderBlock: ((Any) throws -> (Any))?
    
    public override func execute() {
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
    
    public func handleResponse(someData: NSData?, someResponse: NSURLResponse?, someError: NSError?) {
        
    }
    
}