//
//  Collection.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/7/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation

class Collection: Codable {
    
    let uuid: UUID = UUID()
    let name: String
    var pages: [Page]
    
    init(name: String, pages: [Page]) {
        self.name =  name
        self.pages = pages
    }
    
    static func == (left: Collection, right: Collection) -> Bool {
        return left.uuid == right.uuid
    }
    
}
