//
//  DataManager.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/7/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation
import Disk

class DataManager {
    
    private static let dataDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let diskDirectory: Disk.Directory = .documents
    
    class func save(collection: Collection) throws {
        let fileName = (collection.uuid.uuidString as NSString).appendingPathExtension("json")!
        try Disk.save(collection, to: self.diskDirectory, as: fileName)
    }
    
    class func loadCollections() throws -> [Collection] {
        return try FileManager.default.contentsOfDirectory(atPath: self.dataDirectoryURL.path).map { filePath in
            try Disk.retrieve(filePath, from: self.diskDirectory, as: Collection.self)
        }
    }
    
}
