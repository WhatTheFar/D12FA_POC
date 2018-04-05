//
//  ViewController.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 5/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QRCodeScannerSDKDelegate {

    @IBOutlet weak var scanResult: UILabel!
    @IBOutlet weak var scanResultType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanButtonClicked(_ sender: Any) {
        let qrcodeScannerSDKViewController = QRCodeScannerSDKViewController.init(delegate: self, vibrate: true, codeType: QRCodeScannerSDKConstants_QR_CODE + QRCodeScannerSDKConstants_CRONTO_CODE, use: nil, scannerOverlay: true, scannerOverlayColor: nil)
        
        self.present(qrcodeScannerSDKViewController!, animated: true, completion: nil)
    }
    
    func qrCodeScannerSDKController(_ controller: QRCodeScannerSDKViewController!, didScanResult result: String!, withCodeType codeType: Int32) {
        
        scanResult.text = result
        
        if (codeType == QRCodeScannerSDKConstants_QR_CODE) {
            scanResultType.text = "QRCode"
        } else if (codeType == QRCodeScannerSDKConstants_CRONTO_CODE) {
            scanResultType.text = "Color QR Code"
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrCodeScannerSDKControllerDidCancel(_ controller: QRCodeScannerSDKViewController!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrCodeScannerSDKController(_ controller: QRCodeScannerSDKViewController!, threwException exception: QRCodeScannerSDKException!) {
        scanResultType.text = "Exception"
        scanResult.text = String(format:"Error Code : %@", exception.errorCode)
    }
}

