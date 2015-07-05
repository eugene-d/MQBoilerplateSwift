//
//  MQFileManager.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQFileManager {
    
    /**
    Returns the URL of a file in /Document.
    */
    public class func URLForFileName(fileName: String) -> NSURL? {
        return self.URLForFileName(fileName, inFolder: .DocumentDirectory)
    }
    
    /**
    Returns the URL for a file in a given system directory.
    */
    public class func URLForFileName(fileName: String, inFolder folder: NSSearchPathDirectory) -> NSURL? {
        if let systemDirectory = self.URLForSystemFolder(folder) {
            return systemDirectory.URLByAppendingPathComponent(fileName)
        }
        return nil
    }
    
    /**
    Returns the URL for a system folder in the app's sandbox.
    */
    public class func URLForSystemFolder(folder: NSSearchPathDirectory) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let URLs = fileManager.URLsForDirectory(folder, inDomains: .UserDomainMask)
        
        if let lastObject: AnyObject = URLs.last {
            if let  directoryURL = lastObject as? NSURL {
                return directoryURL
            }
        }
        return nil
    }
    
    /**
    Convenience method for checking whether a file exists in /Document.
    */
    public class func findsFileWithName(fileName: String) -> Bool {
        return self.findsFileWithName(fileName, inFolder: .DocumentDirectory)
    }
    
    public class func findsFileWithName(fileName: String, inFolder folder: NSSearchPathDirectory) -> Bool {
        if let filePath = self.URLForFileName(fileName, inFolder: folder) {
            return NSFileManager.defaultManager().fileExistsAtPath(filePath.path!)
        }
        return false
    }
    
    public class func findsFileInURL(fileURL: NSURL) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /**
    Convenience method for writing an object to /Document/fileName.
    */
    public class func writeObject(object: AnyObject, toFileName fileName: String) -> Bool {
        return self.writeObject(object, toFileName: fileName, inFolder: .DocumentDirectory)
    }
    
    public class func writeObject(object: AnyObject, toFileName fileName: String, inFolder folder: NSSearchPathDirectory) -> Bool {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            return NSKeyedArchiver.archiveRootObject(object, toFile: fileURL.path!)
        }
        return false
    }
    
    
    
    
    
    
    
    
    /**
    Convenience method for deflating an object of type T from /Document/fileName.
    */
    public class func objectWithFileName<T>(fileName: String) -> T? {
        return (self.objectWithFileName(fileName, inFolder: .DocumentDirectory) as T?)
    }

    public class func objectWithFileName<T>(fileName: String, inFolder folder: NSSearchPathDirectory) -> T? {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                guard let path = fileURL.path,
                    let object: T = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? T else {
                        fatalError("Cannot convert object at URL '\(fileURL.description)' to type \(T.self)")
                }
                return object
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    /**
    Convenience method for deleting a file in /Document.
    */
    public class func deleteObjectWithFileName(fileName: String, error: NSErrorPointer) {
        self.deleteObjectWithFileName(fileName, inFolder: .DocumentDirectory, error: error)
    }
    
    /**
    
    */
    public class func deleteObjectWithFileName(fileName: String, inFolder folder: NSSearchPathDirectory, error: NSErrorPointer) {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(fileURL)
                } catch let error1 as NSError {
                    error.memory = error1
                }
            }
        }
    }
    
}

public extension MQFileManager {
    
    public class func writeValue<T: MQDataModel>(value: T, toFile fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path else {
                throw MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
        }
        
        let dictionary = value.convertToNSDictionary()
//        if NSKeyedArchiver.archiveRootObject(dictionary, toFile: path) == false {
//            throw MQError("Archiving value \(value) failed.")
//        }
        dictionary.writeToFile(path, atomically: true)
    }
    
    public class func writeValue(value: AnyObject, toFile fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path else {
                throw MQError("Cannot build a file URL to file name '\(fileName)' in '\(folder)'.")
        }
        
        if NSKeyedArchiver.archiveRootObject(value, toFile: path) == false {
            throw MQError("Cannot write value \(value) to file.")
        }
    }
    
    public class func valueAtFile<T: MQDataModel>(fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) -> T? {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder),
            let path = fileURL.path,
            let dictionary = NSDictionary(contentsOfFile: path) else {
                return nil
        }
        
        return T(dictionary: dictionary)
    }
    
    public class func deleteValueAtFile(fileName: String, inFolder folder: NSSearchPathDirectory = .DocumentDirectory) throws {
        guard let fileURL = self.URLForFileName(fileName, inFolder: folder) else {
                return
        }
        
        if self.findsFileInURL(fileURL) {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }
    }
    
}
