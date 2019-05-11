//
//  ReaderViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/23/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var colorPickerBarButtonItem: UIBarButtonItem!
    
    private weak var controlBarView: UIView?
    private var currentWordBoxImageView: WordBoxImageView {
        return (self.collectionView.cellForItem(at: IndexPath(item: self.currentIndex, section: 0)) as! PageCollectionViewCell).wordBoxImageView!
    }
    
    public var collection: Collection?
    public var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title
        self.navigationItem.title = self.collection!.pages[self.currentIndex].name
        
        // Configure the collection view
        self.collectionView.register(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PageCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the color picker bar button item color
        self.updateColorPickerBarButtonItemColor(self.collection!.pages[self.currentIndex].lineColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Scroll to the selected page
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex) * self.view.frame.width, y: 0), animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collection!.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as! PageCollectionViewCell
        cell.wordBoxImageView.page = self.collection!.pages[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let oldIndex = self.currentIndex
        self.currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if oldIndex != self.currentIndex {
            self.updateColorPickerBarButtonItemColor(self.currentWordBoxImageView.page!.lineColor)
            self.navigationItem.title = self.collection!.pages[self.currentIndex].name
            NotificationCenter.default.post(name: .didChangePage, object: nil, userInfo: ["WordBoxImageView": self.currentWordBoxImageView])
        }
    }
    
    // MARK: - UI Actions
    
    @objc func controlValueReceived(_ sender: UIControl) {
        switch sender {
        case is RotationSlider:
            self.currentWordBoxImageView.page!.lineRotationAngle = CGFloat((sender as! RotationSlider).rotationAngle)
        case is LineWidthStepper:
            self.currentWordBoxImageView.page!.lineWidth = CGFloat((sender as! LineWidthStepper).lineWidth)
        case is ColorPicker:
            let color = (sender as! ColorPicker).color
            self.currentWordBoxImageView.page!.lineColor = color
            // Update the bar button item color
            self.updateColorPickerBarButtonItemColor(color)
        default:
            return
        }
        
        // Redraw the lines
        let page = self.collection!.pages[self.currentIndex]
        self.currentWordBoxImageView.drawLines(wordBoxes: page.wordBoxes, lineWidth: page.lineWidth, lineColor: page.lineColor, lineRotationAngle: page.lineRotationAngle)
    }
    
    private func updateColorPickerBarButtonItemColor(_ color: LineColor) {
        switch color {
        case .red, .orange, .yellow, .green, .lightBlue, .blue, .white, .gray:
            self.colorPickerBarButtonItem.tintColor = color.uiColor()
            self.colorPickerBarButtonItem.image = UIImage(named: "ColorPickerIcon")
        case .black:
            self.colorPickerBarButtonItem.image = UIImage(named: "ColorPickerBlackIcon")!
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        // Save changes to disk
        DataManager.shared.update(page: self.collection!.pages[self.currentIndex], in: self.collection!) { result in
            switch result {
            case .success(()):
                return
            case .failure(let error):
                print("Failed to update page in collection: \(self.collection!.pages[self.currentIndex]) \(self.collection!)")
                print("Error: \(error)")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRotationButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is RotationSlider:
            self.dismissControlBar()
        case is LineWidthStepper, is ColorPicker:
            let rotationSlider = UINib(nibName: "RotationSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSlider
            rotationSlider.rotationAngle = self.currentWordBoxImageView.page!.lineRotationAngle
            rotationSlider.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.replaceControlBar(with: rotationSlider)
        default:
            let rotationSlider = UINib(nibName: "RotationSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotationSlider
            rotationSlider.rotationAngle = self.currentWordBoxImageView.page!.lineRotationAngle
            rotationSlider.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.presentControlBar(view: rotationSlider)
        }
    }
    
    @IBAction func didTapLineWidthButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is LineWidthStepper:
            self.dismissControlBar()
        case is RotationSlider, is ColorPicker:
            let lineWidth = UINib(nibName: "LineWidthStepper", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthStepper
            lineWidth.lineWidth = Double(self.currentWordBoxImageView.page!.lineWidth)
            lineWidth.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.replaceControlBar(with: lineWidth)
        default:
            let lineWidth = UINib(nibName: "LineWidthStepper", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineWidthStepper
            lineWidth.lineWidth = Double(self.currentWordBoxImageView.page!.lineWidth)
            lineWidth.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.presentControlBar(view: lineWidth)
        }
    }
    
    @IBAction func didTapColorPickerButton(_ sender: UIBarButtonItem) {
        switch self.controlBarView {
        case is ColorPicker:
            self.dismissControlBar()
        case is RotationSlider, is LineWidthStepper:
            let colorPicker = UINib(nibName: "ColorPicker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPicker
            colorPicker.color = self.currentWordBoxImageView.page!.lineColor
            self.updateColorPickerBarButtonItemColor(colorPicker.color)
            colorPicker.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.replaceControlBar(with: colorPicker)
        default:
            let colorPicker = UINib(nibName: "ColorPicker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColorPicker
            colorPicker.color = self.currentWordBoxImageView.page!.lineColor
            self.updateColorPickerBarButtonItemColor(colorPicker.color)
            colorPicker.addTarget(self, action: #selector(controlValueReceived(_:)), for: .valueChanged)
            self.presentControlBar(view: colorPicker)
        }
    }
    
    private func presentControlBar(view: UIView) {
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
    
    private func dismissControlBar() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.controlBarView!.frame = self.controlBarView!.frame.offsetBy(dx: 0, dy: self.controlBarView!.frame.height)
            self.controlBarView!.alpha = 0
        }) { finished in
            // Unset the control bar
            self.controlBarView!.removeFromSuperview()
            self.controlBarView = nil
        }
    }
    
    private func replaceControlBar(with view: UIView) {
        view.frame = self.controlBarView!.frame
        self.view.addSubview(view)
        self.controlBarView!.removeFromSuperview()
        // Set the new control bar
        self.controlBarView = view
    }

}
