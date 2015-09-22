//
//  MQArchivableValueType.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 7/13/15.
//  Copyright © 2015 Matt Quiros. All rights reserved.
//

import Foundation

public protocol MQArchivableValueType {
    
    /**
    Called by `MQFileManager` to inflate an `MQDataModel` from a file. You shouldn't have to
    call this initializer directly or override its implementation. If the `data` argument can't
    be converted to a Swift dictionary, a fatal error is produced and you should check
    what's wrong with the file.
    */
    init(archiveData data: NSData)
    
    /**
    Called from within `init(archiveData:)` when the data is successfully converted to a dictionary.
    Implement this initializer to set the model's properties to the dictionary's values.
    */
    init(archiveDictionary dict: [String : AnyObject])
    
    /**
    Returns a dictionary representation of this data model so that in can be written to a file.
    You must implement this method to define the key-value pairing in the dictionary.
    */
    func archiveDictionary() -> [String : AnyObject]
    
}

public extension MQArchivableValueType {
    
    init(archiveData data: NSData) {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : AnyObject] else {
            fatalError("Cannot convert to NSData.")
        }
        self.init(archiveDictionary: dictionary)
    }
    
}
