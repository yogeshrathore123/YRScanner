//
//  QRCodeScannerViewController.swift
//  YRScanner
//
//  Created by Yogesh Rathore on 25/05/19.
//  Copyright © 2019 Yogesh Rathore. All rights reserved.
//

import UIKit

import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    var scanner : YRQRCodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func scanQRCodeTapped(_ sender: Any) {
        if #available(iOS 10.2, *) {
            self.scanner = YRQRCodeScanner(withViewController: self, view: self.view, codeOutputHandler: self.handleCode)
            if let scanner = self.scanner{
                scanner.startScanning()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func handleCode(code: String) {
        let alertController = UIAlertController(title: "QR code Scanned", message:
            code, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            print("OK")
        }))
        alertController.addAction(UIAlertAction(title: "Dismis", style: .cancel, handler: { (alert) in
            print("Dismis")
            DispatchQueue.main.async {
                
                self.dismiss(animated: true, completion: nil)
            }
            //self.dismiss(animated: true, completion: nil)
            // self.scanner?.stopScanning()
            // self.navigationController?.popToRootViewController(animated: true)
        }))
        //        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: { () in print("Done🔨") }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

