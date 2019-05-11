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
    var lineWidth: CGFloat = 1
    var lineColor: LineColor = .black
    var lineRotationAngle: CGFloat = 0 // radians
    
    enum CodingKeys: String, CodingKey {
        case name, image, wordBoxes, lineWidth, lineColor, lineRotationAngle
    }
    
    init(name: String, image: UIImage, wordBoxes: [CGRect]) {
        self.name = name
        self.image = image
        self.wordBoxes = wordBoxes
    }
    
    static func == (left: Page, right: Page) -> Bool {
        return left.image == right.image
    }
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.wordBoxes = try container.decode([CGRect].self, forKey: .wordBoxes)
        let data = try container.decode(Data.self, forKey: .image)
        let image = UIImage(data: data)!
        self.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        self.lineWidth = try container.decode(CGFloat.self, forKey: .lineWidth)
        self.lineColor = try container.decode(LineColor.self, forKey: .lineColor)
        self.lineRotationAngle = try container.decode(CGFloat.self, forKey: .lineRotationAngle)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.wordBoxes, forKey: .wordBoxes)
        let data = self.image.pngData()
        try container.encodeIfPresent(data, forKey: .image)
        try container.encode(self.lineWidth, forKey: .lineWidth)
        try container.encode(self.lineColor, forKey: .lineColor)
        try container.encode(self.lineRotationAngle, forKey: .lineRotationAngle)
    }
    
}
