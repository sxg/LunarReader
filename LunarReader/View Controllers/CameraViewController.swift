//
//  CameraViewController.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/3/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController, PulleyPrimaryContentControllerDelegate {
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    
    private let cameraSession: AVCaptureSession = AVCaptureSession()
    private let cameraButtonBottomDistance: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure camera
        self.cameraSession.beginConfiguration()
        let camera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera!), cameraSession.canAddInput(cameraInput) else { return }
        self.cameraSession.addInput(cameraInput)
        let photoOutput = AVCapturePhotoOutput()
        guard self.cameraSession.canAddOutput(photoOutput) else { return }
        self.cameraSession.sessionPreset = .photo
        self.cameraSession.addOutput(photoOutput)
        self.cameraSession.commitConfiguration()
        
        // Connect the camera to the view, resize the video feed, and start the camera
        self.cameraView.cameraPreviewLayer.session = cameraSession
        self.cameraView.cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraSession.startRunning()
    }
    
    // MARK: - PulleyPrimaryContentControllerDelegate
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        // Move the camera button with the drawer
        self.cameraButtonBottomConstraint.constant = CGFloat.minimum(264, distance) + self.cameraButtonBottomDistance
    }
    
}
