//
//  ReaderViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/23/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private weak var controlBarView: UIView?
    
    public var page: Page?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title
        self.navigationItem.title = self.page!.name
        
        // Set the page
        self.imageView.image = self.page!.image
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapLineWidthButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is LineWidthView:
            // Dismiss the line width stepper
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.controlBarView!.frame = self.controlBarView!.frame.offsetBy(dx: 0, dy: self.controlBarView!.frame.height)
                self.controlBarView!.alpha = 0
            }) { finished in
                // Unset the control bar
                self.controlBarView!.removeFromSuperview()
                self.controlBarView = nil
            }
        case is UIView:
            // Replace the control bar
            let lineWidthView = UINib(nibName: "LineWidthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthView
            lineWidthView.frame = self.controlBarView!.frame
            self.view.addSubview(lineWidthView)
            self.controlBarView!.removeFromSuperview()
            // Set the new control bar
            self.controlBarView = lineWidthView
        default:
            // Slide the line width stepper up if there is no control bar
            let lineWidthView = UINib(nibName: "LineWidthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthView
            lineWidthView.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height, width: self.view.frame.width, height: 56)
            lineWidthView.alpha = 0
            self.view.addSubview(lineWidthView)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                lineWidthView.frame = lineWidthView.frame.offsetBy(dx: 0, dy: -lineWidthView.frame.height)
                lineWidthView.alpha = 1
            })
            // Set the new control bar
            self.controlBarView = lineWidthView
        }
    }
    
    @IBAction func didTapColorPickerButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is ColorPickerView:
            // Dismiss the color picker
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.controlBarView!.frame = self.controlBarView!.frame.offsetBy(dx: 0, dy: self.controlBarView!.frame.height)
                self.controlBarView!.alpha = 0
            }) { finished in
                // Unset the control bar
                self.controlBarView!.removeFromSuperview()
                self.controlBarView = nil
            }
        case is UIView:
            // Replace the control bar
            let colorPicker = UINib(nibName: "ColorPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPickerView
            colorPicker.frame = self.controlBarView!.frame
            self.view.addSubview(colorPicker)
            self.controlBarView!.removeFromSuperview()
            // Set the new control bar
            self.controlBarView = colorPicker
        default:
            // Slide the color picker up if there is no control bar
            let colorPicker = UINib(nibName: "ColorPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPickerView
            colorPicker.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height, width: self.view.frame.width, height: 56)
            colorPicker.alpha = 0
            self.view.addSubview(colorPicker)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                colorPicker.frame = colorPicker.frame.offsetBy(dx: 0, dy: -colorPicker.frame.height)
                colorPicker.alpha = 1
            })
            // Set the new control bar
            self.controlBarView = colorPicker
        }
    }

    // MARK: - Navigation
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

private enum ControlBar {
    case rotationSlider
    case lineWidthStepper
    case colorPicker
}
