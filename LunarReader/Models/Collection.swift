//
//  Collection.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/7/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation

struct Collection: Codable {
    
    let name: String
    let pages: [Page]?
    
    init(name: String, pages: [Page]? = nil) {
        self.name =  name
        self.pages = pages
    }
    
}
