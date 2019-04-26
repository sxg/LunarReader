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
    
    // MARK: - UI Actions
    
    @objc func controlValueReceived(_ sender: UIControl) {
        switch sender {
        case is RotationSlider:
            print((sender as! RotationSlider).rotationAngle)
        case is LineWidthStepper:
            print((sender as! LineWidthStepper).value)
        case is ColorPickerView:
            return
        default:
            return
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapRotationButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is RotationSlider:
            self.dismissControlBar()
        case is LineWidthStepper, is ColorPickerView:
            let rotationSlider = UINib(nibName: "RotationSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSlider
            rotationSlider.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.replaceControlBar(with: rotationSlider)
        default:
            let rotationSlider = UINib(nibName: "RotationSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSlider
            rotationSlider.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.presentControlBar(view: rotationSlider)
        }
    }
    
    @IBAction func didTapLineWidthButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is LineWidthStepper:
            self.dismissControlBar()
        case is RotationSlider, is ColorPickerView:
            let lineWidth = UINib(nibName: "LineWidthStepper", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthStepper
            lineWidth.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.replaceControlBar(with: lineWidth)
        default:
            let lineWidth = UINib(nibName: "LineWidthStepper", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthStepper
            lineWidth.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.presentControlBar(view: lineWidth)
        }
    }
    
    @IBAction func didTapColorPickerButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is ColorPickerView:
            self.dismissControlBar()
        case is RotationSlider, is LineWidthStepper:
            let colorPicker = UINib(nibName: "ColorPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPickerView
            self.replaceControlBar(with: colorPicker)
        default:
            let colorPicker = UINib(nibName: "ColorPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPickerView
            self.presentControlBar(view: colorPicker)
        }
    }
    
    func presentControlBar(view: UIView) {
        view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.height, width: self.view.frame.width, height: 56)
        view.alpha = 0
        self.view.addSubview(view)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            view.frame = view.frame.offsetBy(dx: 0, dy: -view.frame.height)
            view.alpha = 1
        })
        // Set the new control bar
        self.controlBarView = view
    }
    
    func dismissControlBar() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.controlBarView!.frame = self.controlBarView!.frame.offsetBy(dx: 0, dy: self.controlBarView!.frame.height)
            self.controlBarView!.alpha = 0
        }) { finished in
            // Unset the control bar
            self.controlBarView!.removeFromSuperview()
            self.controlBarView = nil
        }
    }
    
    func replaceControlBar(with view: UIView) {
        view.frame = self.controlBarView!.frame
        self.view.addSubview(view)
        self.controlBarView!.removeFromSuperview()
        // Set the new control bar
        self.controlBarView = view
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
