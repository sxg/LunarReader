//
//  CameraView.swift
//  LunarReader
//
//  Created by Satyam Ghodasara on 4/4/19.
//  Copyright © 2019 Satyam Ghodasara. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
}
