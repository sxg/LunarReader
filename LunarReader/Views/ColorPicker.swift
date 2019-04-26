//
//  ColorPicker.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/24/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ColorPicker: UIControl {

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var lightBlueButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var grayButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    
    var color: UIColor = UIColor(named: "Red")!
    
    // MARK: UI Actions
    
    @IBAction func didTapColorButton(_ sender: UIButton) {
        switch sender {
        case redButton:
            color = UIColor(named: "Red")!
        case orangeButton:
            color = UIColor(named: "Orange")!
        case yellowButton:
            color = UIColor(named: "Yellow")!
        case greenButton:
            color = UIColor(named: "Green")!
        case lightBlueButton:
            color = UIColor(named: "LightBlue")!
        case blueButton:
            color = UIColor(named: "Blue")!
        case whiteButton:
            color = UIColor(named: "White")!
        case grayButton:
            color = UIColor(named: "Gray")!
        case blackButton:
            color = UIColor(named: "Black")!
        default:
            return
        }
        self.sendActions(for: .valueChanged)
    }
    
}
