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
import Photos
import Pulley

class CameraViewController: UIViewController, PulleyPrimaryContentControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    
    private let cameraSession: AVCaptureSession = AVCaptureSession()
    private let photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    private let cameraButtonBottomDistance: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure camera
        self.cameraSession.beginConfiguration()
        let camera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera!), cameraSession.canAddInput(cameraInput) else { return }
        self.cameraSession.addInput(cameraInput)
        guard self.cameraSession.canAddOutput(self.photoOutput) else { return }
        self.cameraSession.sessionPreset = .photo
        self.cameraSession.addOutput(self.photoOutput)
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
    
    // MARK: - AVCapturePhotoCaptureDelegate
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { print("Error capturing photo: \(error!)"); return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let photoCreationRequest = PHAssetCreationRequest.forAsset()
                photoCreationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)
            }, completionHandler: { (success, error) in
                guard error == nil else { print("Error saving photo: \(error!)"); return }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "NewPageViewControllerSegue", sender: photo)
                }
            })
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func didTapCameraButton(sender: UIButton, forEvent event: UIEvent) {
        // Configure photo output settings
        let photoOutputSettings = AVCapturePhotoSettings()
        photoOutputSettings.flashMode = .auto
        
        // Capture the photo
        self.photoOutput.capturePhoto(with: photoOutputSettings, delegate: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewPageViewControllerSegue":
        // Prepare the NewPageViewController with the captured image
        let newPageViewController = (segue.destination as! UINavigationController).viewControllers.first as! NewPageViewController
            let photo = sender as! AVCapturePhoto
            newPageViewController.image = UIImage(data: photo.fileDataRepresentation()!)
        default:
            break
        }
    }

}
