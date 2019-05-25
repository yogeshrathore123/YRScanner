//
//  DocumentViewController.swift
//  YRScanner
//
//  Created by Yogesh Rathore on 25/05/19.
//  Copyright © 2019 Yogesh Rathore. All rights reserved.
//

import UIKit
import WeScan

class DocumentViewController: UIViewController, ImageScannerControllerDelegate {

    @IBOutlet weak var scannedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
        
        // Do any additional setup after loading the view.
    }
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
        scannedImageView.image = results.scannedImage
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
    
}
