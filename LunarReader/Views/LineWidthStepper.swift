//
//  LineWidthStepper.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/24/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit
import ValueStepper

class LineWidthStepper: UIControl {

    @IBOutlet weak var stepper: ValueStepper!
    
    var value: Double {
        get {
            return stepper.value
        }
    }
    
    // MARK: UIControl
    
    @IBAction func stepperValueChanged(_ sender: ValueStepper) {
        self.sendActions(for: .valueChanged)
    }

}
