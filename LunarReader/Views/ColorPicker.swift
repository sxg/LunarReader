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
    
    private weak var selectedColorButton: UIButton? {
        didSet {
            // Remove the old checkmark
            oldValue?.setImage(nil, for: .normal)
            // Assign the new checkmark
            switch color {
            case .red, .orange, .yellow, .green, .lightBlue, .blue, .white, .gray:
                self.selectedColorButton!.setImage(ColorPicker.checkmarkIcon, for: .normal)
            case .black:
                self.selectedColorButton!.setImage(ColorPicker.whiteCheckmarkIcon, for: .normal)
            }
        }
    }
    
    var color = LineColor.black {
        didSet {
            self.selectedColorButton = { // Update the selected color button
                switch self.color {
                case .red: return self.redButton
                case .orange: return self.orangeButton
                case .yellow: return self.yellowButton
                case .green: return self.greenButton
                case .lightBlue: return self.lightBlueButton
                case .blue: return self.blueButton
                case .white: return self.whiteButton
                case .gray: return self.grayButton
                case .black: return self.blackButton
                }
            }()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add observer for page changes
        NotificationCenter.default.addObserver(forName: .didChangePage, object: nil, queue: OperationQueue.main) { notification in
            let wordBoxImageView = notification.userInfo!["WordBoxImageView"] as! WordBoxImageView
            self.color = wordBoxImageView.page!.lineColor
        }
    }
    
    // MARK: UI Actions
    
    @IBAction func didTapColorButton(_ sender: UIButton) {
        self.color = { // Set the color based on which color button was tapped
            switch sender {
            case redButton: return .red
            case orangeButton: return .orange
            case yellowButton: return .yellow
            case greenButton: return .green
            case lightBlueButton: return .lightBlue
            case blueButton: return .blue
            case whiteButton: return .white
            case grayButton: return .gray
            case blackButton: return .black
            default: return .black
            }
        }()
        
        // Inform the target
        self.sendActions(for: .valueChanged)
    }
    
}
