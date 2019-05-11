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
    
    var lineWidth: Double {
        // Link to the stepper's value
        get {
            return self.stepper.value
        }
        set {
            self.stepper.value = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add observer for page changes
        NotificationCenter.default.addObserver(forName: .didChangePage, object: nil, queue: OperationQueue.main) { notification in
            let wordBoxImageView = notification.userInfo!["WordBoxImageView"] as! WordBoxImageView
            self.lineWidth = Double(wordBoxImageView.page!.lineWidth)
        }
    }
    
    // MARK: UIControl
    
    @IBAction func stepperValueChanged(_ sender: ValueStepper) {
        // Inform the target
        self.sendActions(for: .valueChanged)
    }

}
