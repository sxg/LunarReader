//
//  Collection.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/7/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation

class Collection: Codable {
    
    let name: String
    let pages: [Page]
    let uuid: UUID = UUID()
    
    init(name: String, pages: [Page]) {
        self.name =  name
        self.pages = pages
    }
    
}
