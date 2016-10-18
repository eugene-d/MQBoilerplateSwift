//
//  MQFileManager.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/16/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import Foundation

open class MQFileManager {
    
    // MARK: Convenience methods
    
    /**
    Convenience method for returning the URL of a file in /Document.
    */
    open class func URLForFileName(_ fileName: String) -> URL? {
        return self.URLForFileName(fileName, inFolder: .documentDirectory)
    }
    
    /**
    Convenience method for checking whether a file exists in /Document.
    */
    open class func findsFileWithName(_ fileName: String) -> Bool {
        return self.findsFileWithName(fileName, inFolder: .documentDirectory)
    }
    
    /**
    Convenience method for writing an object to /Document/fileName.
    */
    open class func writeObject(_ object: AnyObject, toFileName fileName: String) -> Bool {
        return self.writeObject(object, toFileName: fileName, inFolder: .documentDirectory)
    }
    
    /**
    Convenience method for deflating an object of type T from /Document/fileName.
    */
    open class func objectWithFileName<T>(_ fileName: String) -> T? {
        return (self.objectWithFileName(fileName, inFolder: .documentDirectory) as T?)
    }
    
    /**
    Convenience method for deleting a file in /Document.
    */
    open class func deleteObjectWithFileName(_ fileName: String, error: NSErrorPointer) {
        self.deleteObjectWithFileName(fileName, inFolder: .documentDirectory, error: error)
    }
    
    // MARK: Base methods
    
    /**
    Returns the URL for a system folder in the app's sandbox.
    */
    open class func URLForSystemFolder(_ folder: FileManager.SearchPathDirectory) -> URL? {
        let fileManager = FileManager.default
        let URLs = fileManager.urls(for: folder, in: .userDomainMask)
        
        if let lastObject: AnyObject = URLs.last as AnyObject? {
            if let  directoryURL = lastObject as? URL {
                return directoryURL
            }
        }
        return nil
    }
    
    /**
    Returns the URL for a file in a given system directory.
    */
    open class func URLForFileName(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> URL? {
        if let systemDirectory = self.URLForSystemFolder(folder) {
            return systemDirectory.appendingPathComponent(fileName)
        }
        return nil
    }
    
    open class func findsFileWithName(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> Bool {
        if let filePath = self.URLForFileName(fileName, inFolder: folder) {
            return FileManager.default.fileExists(atPath: filePath.path)
        }
        return false
    }
    
    open class func findsFileInURL(_ fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    open class func writeObject(_ object: AnyObject, toFileName fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> Bool {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            return NSKeyedArchiver.archiveRootObject(object, toFile: fileURL.path)
        }
        return false
    }
    
    open class func objectWithFileName<T>(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory) -> T? {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                
                if let object = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) {
                    if let typedObject = object as? T {
                        return typedObject
                    }
                }
            }
        }
        return nil
    }
    
    open class func deleteObjectWithFileName(_ fileName: String, inFolder folder: FileManager.SearchPathDirectory, error: NSErrorPointer) {
        if let fileURL = self.URLForFileName(fileName, inFolder: folder) {
            if self.findsFileInURL(fileURL) {
                
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch let error1 as NSError {
                    error?.pointee = error1
                }
            }
        }
    }
    
}
