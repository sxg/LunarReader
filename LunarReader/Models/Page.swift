//
//  Page.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/7/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation
import UIKit

class Page: Codable {
    
    let name: String
    let image: UIImage
    let wordBoxes: [CGRect]
    
    enum CodingKeys: String, CodingKey {
        case name
        case image
        case wordBoxes
    }
    
    init(name: String, image: UIImage, wordBoxes: [CGRect]) {
        self.name = name
        self.image = image
        self.wordBoxes = wordBoxes
    }
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.wordBoxes = try container.decode([CGRect].self, forKey: CodingKeys.wordBoxes)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        self.image = UIImage(data: data)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: CodingKeys.name)
        try container.encode(self.wordBoxes, forKey: CodingKeys.wordBoxes)
        let data = self.image.pngData()
        try container.encodeIfPresent(data, forKey: CodingKeys.image)
    }
    
}
