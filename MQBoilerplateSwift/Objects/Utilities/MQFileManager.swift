//
//  MQFileManager.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

public class MQFileManager {
    
    // MARK: Convenience methods
    
    /**
    Convenience method for returning the URL of a file in /Document.
    */
    public class func URLForFileName(fileName: String) -> NSURL? {
        return self.URLForFileName(fileName, inFolder: .DocumentDirectory)
    }
    
    /**
    Convenience method for checking whether a file exists in /Document.
    */
    public class func findsFileWithName(fileName: String) -> Bool {
        return self.findsFileWithName(fileName, inFolder: .DocumentDirectory)
    }
    
    /**
    Convenience method for writing an object to /Document/fileName.
    */
    public class func writeObject(object: AnyObject, toFileName fileName: String) -> Bool {
        return self.writeObject(object, toFileName: fileName, inFolder: .DocumentDirectory)
    }
    
    /**
    Convenience method for deflating an object of type T from /Document/fileName.
    */
    public class func objectWithFileName<T>(fileName: String) -> T? {
        return (self.objectWithFileName(fileName, inFolder: .DocumentDirectory) as T?)
    }
    
    /**
    Convenience method for deleting a file in /Document.
    */
    public class func deleteObjectWithFileName(fileName: String, error: NSErrorPointer) {
        self.deleteObjectWithFileName(fileName, inFolder: .DocumentDirectory, error: error)
    }
    
    // MARK: Base methods
    
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
    Returns the URL for a file in a given system directory.
    */
    public class func URLForFileName(fileName: String, inFolder folder: NSSearchPathDirectory) -> NSURL? {
        if let systemDirectory = self.URLForSystemFolder(folder) {
            return systemDirectory.URLByAppendingPathComponent(fileName)
        }
        return nil
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
    
    public class func writeObject(object: AnyObject, toFileName fileName: String, inFolder folder: NSSearchPathDirectory) -> Bool {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            return NSKeyedArchiver.archiveRootObject(object, toFile: fileURL.path!)
        }
        return false
    }
    
    public class func objectWithFileName<T>(fileName: String, inFolder folder: NSSearchPathDirectory) -> T? {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                
                if let object: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(fileURL.path!) {
                    if let typedObject = object as? T {
                        return typedObject
                    }
                }
            }
        }
        return nil
    }
    
    public class func deleteObjectWithFileName(fileName: String, inFolder folder: NSSearchPathDirectory, error: NSErrorPointer) {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                
                NSFileManager.defaultManager().removeItemAtURL(fileURL, error: error)
            }
        }
    }
    
}