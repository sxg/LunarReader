//
//  LineColor.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 5/10/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation
import UIKit

enum LineColor: Int, Codable {
    case red, orange, yellow, green, lightBlue, blue, white, gray, black
    
    private static let redColor: UIColor = UIColor(named: "Red")!
    private static let orangeColor: UIColor = UIColor(named: "Orange")!
    private static let yellowColor: UIColor = UIColor(named: "Yellow")!
    private static let greenColor: UIColor = UIColor(named: "Green")!
    private static let lightBlueColor: UIColor = UIColor(named: "LightBlue")!
    private static let blueColor: UIColor = UIColor(named: "Blue")!
    private static let whiteColor: UIColor = UIColor(named: "White")!
    private static let grayColor: UIColor = UIColor(named: "Gray")!
    private static let blackColor: UIColor = UIColor(named: "Black")!
    
    func uiColor() -> UIColor {
        switch self {
        case .red: return LineColor.redColor
        case .orange: return LineColor.orangeColor
        case .yellow: return LineColor.yellowColor
        case .green: return LineColor.greenColor
        case .lightBlue: return LineColor.lightBlueColor
        case .blue: return LineColor.blueColor
        case .white: return LineColor.whiteColor
        case .gray: return LineColor.grayColor
        case .black: return LineColor.blackColor
        }
    }
}
