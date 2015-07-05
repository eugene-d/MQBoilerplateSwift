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
    init(dictionary: NSDictionary)
    
    func convertToNSDictionary() -> NSDictionary
    static func formFieldsFromInstance(instance: Self) -> [MQField]
    
}

public extension MQDataModel {
    
    init(data: NSData) {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary else {
            fatalError("Cannot convert to NSData.")
        }
        self.init(dictionary: dictionary)
    }
    
}