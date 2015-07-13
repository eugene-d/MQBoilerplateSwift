//
//  MQDataModel.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/3/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public protocol MQDataModel {
    
    init(data: NSData)
    init(dictionary: [String : AnyObject])
    
    func convertToDictionary() -> [String : AnyObject]
    static func formFieldsFromInstance(instance: Self) -> [MQField]
    
}

public extension MQDataModel {
    
    init(data: NSData) {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : AnyObject] else {
            fatalError("Cannot convert to NSData.")
        }
        self.init(dictionary: dictionary)
    }
    
    static func formFieldsFromInstance(instance: Self) -> [MQField] {
        fatalError("Unimplemented \(__FUNCTION__)")
    }
    
}