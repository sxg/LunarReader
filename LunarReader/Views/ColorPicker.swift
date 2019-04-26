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
    
    private static let checkmarkIcon: UIImage = UIImage(named: "CheckmarkIcon")!
    private static let whiteCheckmarkIcon: UIImage = UIImage(named: "CheckmarkIcon")!.withRenderingMode(.alwaysTemplate)
    
    private static let redColor: UIColor = UIColor(named: "Red")!
    private static let orangeColor: UIColor = UIColor(named: "Orange")!
    private static let yellowColor: UIColor = UIColor(named: "Yellow")!
    private static let greenColor: UIColor = UIColor(named: "Green")!
    private static let lightBlueColor: UIColor = UIColor(named: "LightBlue")!
    private static let blueColor: UIColor = UIColor(named: "Blue")!
    private static let whiteColor: UIColor = UIColor(named: "White")!
    private static let grayColor: UIColor = UIColor(named: "Gray")!
    private static let blackColor: UIColor = UIColor(named: "Black")!
    
    private lazy var selectedColorButton: UIButton = self.redButton
    
    lazy var color: UIColor = ColorPicker.redColor
    
    // MARK: UI Actions
    
    @IBAction func didTapColorButton(_ sender: UIButton) {
        switch sender {
        case redButton:
            self.color = ColorPicker.redColor
        case orangeButton:
            self.color = ColorPicker.orangeColor
        case yellowButton:
            self.color = ColorPicker.yellowColor
        case greenButton:
            self.color = ColorPicker.greenColor
        case lightBlueButton:
            self.color = ColorPicker.lightBlueColor
        case blueButton:
            self.color = ColorPicker.blueColor
        case whiteButton:
            self.color = ColorPicker.whiteColor
        case grayButton:
            self.color = ColorPicker.grayColor
        case blackButton:
            self.color = ColorPicker.blackColor
        default:
            return
        }
        
        // Remove the checkmark from the previous selection and add it to the new one
        self.selectedColorButton.setImage(nil, for: .normal)
        self.selectedColorButton = sender
        if sender != self.blackButton {
            self.selectedColorButton.setImage(ColorPicker.checkmarkIcon, for: .normal)
        } else {
            self.blackButton.imageView?.tintColor = ColorPicker.whiteColor
            self.blackButton.setImage(ColorPicker.whiteCheckmarkIcon, for: .normal)
        }
        
        self.sendActions(for: .valueChanged)
    }
    
}
