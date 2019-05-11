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
    private(set) var collections: [Collection] = []
    
    private let backgroundQueue = DispatchQueue(label: "io.Satyam.LunarReader.backgroundQueue", qos: .background)
    
    private static let dataDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let diskDirectory: Disk.Directory = .documents
    
    func add(collection: Collection, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard !self.collections.contains(where: {$0 == collection}) else { completionHandler(.failure(DataManagerError.duplicateCollection(collection))); return }
        self.collections.append(collection)
        
        // Save to disk
        self.save(collection: collection, completionHandler: completionHandler)
    }
    
    func add(page: Page, to collection: Collection, completionHandler: @escaping (Result<Void, Error>) ->  Void) {
        guard self.collections.contains(where: {$0 == collection}) else { completionHandler(.failure(DataManagerError.collectionNotFound(collection))); return }
        collection.pages.append(page)
        
        // Save to disk
        self.save(collection: collection, completionHandler: completionHandler)
    }
    
    func remove(collection: Collection, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard self.collections.contains(where: {$0 == collection}) else { completionHandler(.failure(DataManagerError.collectionNotFound(collection))); return }
        self.collections.removeAll(where: {$0 == collection})
        
        // Delete from disk
        self.delete(collection: collection, completionHandler: completionHandler)
    }
    
    func remove(page: Page, from collection: Collection, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard self.collections.contains(where: {$0 == collection}) else { completionHandler(.failure(DataManagerError.collectionNotFound(collection))); return }
        guard collection.pages.contains(where: {$0 == page}) else { completionHandler(.failure(DataManagerError.pageNotFound(page))); return }
        collection.pages.removeAll(where: {$0 == page})
        
        // Update disk
        if collection.pages.count == 0 {
            self.remove(collection: collection, completionHandler: completionHandler)
        } else {
            self.save(collection: collection, completionHandler: completionHandler)
        }
    }
    
    func update(page: Page, in collection: Collection, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard self.collections.contains(where: {$0 == collection}) else { completionHandler(.failure(DataManagerError.collectionNotFound(collection))); return }
        guard collection.pages.contains(where: {$0 == page}) else { completionHandler(.failure(DataManagerError.pageNotFound(page))); return }
        
        // Save to disk
        self.save(collection: collection, completionHandler: completionHandler)
    }
    
    func loadCollections(completionHandler: ((Result<[Collection], Error>) -> Void)? = nil) {
        self.backgroundQueue.async {
            do {
                // Load collections from disk and sort by creation time
                let collections = try FileManager.default.contentsOfDirectory(atPath: DataManager.dataDirectoryURL.path).map { filePath in
                    try Disk.retrieve(filePath, from: DataManager.diskDirectory, as: Collection.self)
                }
                self.collections = collections.sorted { $0.createdAt < $1.createdAt }
                if let completionHandler  = completionHandler {
                    DispatchQueue.main.async {
                        completionHandler(.success(self.collections))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    if let completionHandler = completionHandler {
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    
    private func save(collection: Collection,  completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let fileName = (collection.uuid.uuidString as NSString).appendingPathExtension("json")!
        self.backgroundQueue.async {
            do {
                NotificationCenter.default.post(name: Notification.Name.willSaveCollection, object: collection)
                try Disk.save(collection, to: DataManager.diskDirectory, as: fileName)
                NotificationCenter.default.post(name: Notification.Name.didSaveCollection, object: collection)
                DispatchQueue.main.async {
                    completionHandler(.success(()))
                }
            } catch let error {
                NotificationCenter.default.post(name: Notification.Name.didFailToSaveCollection, object: collection)
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    private func delete(collection: Collection, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let fileName = (collection.uuid.uuidString as NSString).appendingPathExtension("json")!
        self.backgroundQueue.async {
            do {
                NotificationCenter.default.post(name: Notification.Name.willDeleteCollection, object: collection)
                try Disk.remove(fileName, from: DataManager.diskDirectory)
                NotificationCenter.default.post(name: Notification.Name.didDeleteCollection, object: collection)
                DispatchQueue.main.async {
                    completionHandler(.success(()))
                }
            } catch let error {
                NotificationCenter.default.post(name: Notification.Name.didFailToDeleteCollection, object: collection)
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
}

enum DataManagerError: Error {
    case duplicateCollection(Collection)
    case collectionNotFound(Collection)
    case pageNotFound(Page)
}
