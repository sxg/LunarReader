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
    
    // Singleton instance
    public static let shared: DataManager = DataManager()
    public var collections: [Collection] = []
    
    private static let dataDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let diskDirectory: Disk.Directory = .documents
    
    func save(collection: Collection) {
        let fileName = (collection.uuid.uuidString as NSString).appendingPathExtension("json")!
        DispatchQueue.main.async {
            do {
                try Disk.save(collection, to: DataManager.diskDirectory, as: fileName)
            } catch {
                print("Error saving collection: \(error)")
            }
        }
    }
    
    func saveAll() {
        self.collections.forEach { collection in
            self.save(collection: collection)
        }
    }
    
    func add(collection: Collection) throws {
        guard !self.collections.contains(where: {$0.uuid == collection.uuid}) else { throw DataManagerError.duplicateCollectionError(collection) }
        self.collections.append(collection)
    }
    
    func loadCollections() {
        // Load collections from disk and sort by name
        let collections = try! FileManager.default.contentsOfDirectory(atPath: DataManager.dataDirectoryURL.path).map { filePath in
            try Disk.retrieve(filePath, from: DataManager.diskDirectory, as: Collection.self)
        }
        self.collections = collections.sorted { $0.name < $1.name }
    }
    
}

enum DataManagerError: Error {
    case duplicateCollectionError(Collection)
    case collectionDoesNotExistError(Collection)
}
