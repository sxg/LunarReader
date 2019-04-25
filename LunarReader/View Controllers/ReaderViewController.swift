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
    
    @IBAction func didTapRotationButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is RotationSliderView:
            self.dismissControlBar()
        case is UIView:
            let rotationSliderView = UINib(nibName: "RotationSliderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSliderView
            self.replaceControlBar(with: rotationSliderView)
        default:
            let rotationSliderView = UINib(nibName: "RotationSliderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSliderView
            self.presentControlBar(view: rotationSliderView)
        }
    }
    
    @IBAction func didTapLineWidthButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is LineWidthView:
            self.dismissControlBar()
        case is UIView:
            let lineWidthView = UINib(nibName: "LineWidthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthView
            self.replaceControlBar(with: lineWidthView)
        default:
            let lineWidthView = UINib(nibName: "LineWidthView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthView
            self.presentControlBar(view: lineWidthView)
        }
    }
    
    @IBAction func didTapColorPickerButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is ColorPickerView:
            self.dismissControlBar()
        case is UIView:
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
