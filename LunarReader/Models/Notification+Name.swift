//
//  Notification+Name.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/11/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let willSaveCollection = Notification.Name("willSaveCollection")
    static let didSaveCollection = Notification.Name("didSaveCollection")
    static let didFailToSaveCollection = Notification.Name("didFailToSaveCollection")
    static let willDeleteCollection = Notification.Name("willDeleteCollection")
    static let didDeleteCollection = Notification.Name("didDeleteCollection")
    static let didFailToDeleteCollection = Notification.Name("didFailToDeleteCollection")
    
    static let didChangePage = Notification.Name("didChangePage")
    
}
