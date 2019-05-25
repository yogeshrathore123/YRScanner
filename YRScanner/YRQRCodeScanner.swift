//
//  YRQRCodeScanner.swift
//  YRScanner
//
//  Created by Yogesh Rathore on 25/05/19.
//  Copyright © 2019 Yogesh Rathore. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class YRQRCodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    let qrCodeFrameView: UIView = UIView()
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession
    private var codeOutputHandler: (_ code: String) ->  Void
    
    public init(withViewController viewController: UIViewController, view: UIView, codeOutputHandler: @escaping (String) -> Void) {
        self.viewController = viewController
        self.codeOutputHandler = codeOutputHandler
        self.captureSession = AVCaptureSession()
        super.init()
    }
    
    @available(iOS 10.2, *)
    public func startScanning() {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        let captureDevice = deviceDiscoverySession.devices.first
        //        let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera,
        //                                                                      for: .video, position: .back)
        if captureDevice == nil {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            if videoPreviewLayer != nil {
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = viewController.view.layer.bounds
                viewController.view.layer.addSublayer(videoPreviewLayer!)
                
                // Start video capture.
                captureSession.startRunning()
                
                if let hasFlash = captureDevice?.hasFlash, let hasTorch = captureDevice?.hasTorch {
                    if hasFlash && hasTorch {
                        //                        view.bringSubview(toFront: bottomBar)
                        try captureDevice?.lockForConfiguration()
                    }
                }
            }
            
            // QR Code Overlay
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            viewController.view.addSubview(qrCodeFrameView)
            viewController.view.bringSubviewToFront(qrCodeFrameView)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print("Error: \(error)")
            return
        }
    }
    
    func stopScanning() {
        if captureSession.isRunning
        {
            captureSession.stopRunning()
        }
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView.frame = barCodeObject!.bounds
        
        if metadataObj.stringValue != nil {
            print(metadataObj.stringValue ?? "")
            self.codeOutputHandler(metadataObj.stringValue ?? "")
        }
    }
}


