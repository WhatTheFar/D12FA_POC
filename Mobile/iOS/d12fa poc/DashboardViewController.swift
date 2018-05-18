//
//  DashboardViewController.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 9/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QRCodeScannerSDKDelegate {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var scanResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.asCircle()
        ProfileImage.layer.borderColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        ProfileImage.layer.borderWidth = 1.0
        
        let g = UITapGestureRecognizer(target: self, action:  #selector (self.ProfileImageChangeClick (_:)))
        ProfileImage.isUserInteractionEnabled = true
        ProfileImage.addGestureRecognizer(g)
        
        if let image = Utils.getProfileImage() {
            ProfileImage.image = image
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let name = Utils.getName()
        NameLabel.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func ProfileImageChangeClick(_ sender:UITapGestureRecognizer) {
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        actionSheetController.popoverPresentationController?.sourceView = ProfileImage
        actionSheetController.popoverPresentationController?.sourceRect = ProfileImage.bounds
        
        let takePictureAction = UIAlertAction(title: "Take Camera", style: .default) { action -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        actionSheetController.addAction(takePictureAction)
        
        let fromGalleryAction = UIAlertAction(title: "From Gallery", style: .default) { action -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        actionSheetController.addAction(fromGalleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var success = false
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            success = Utils.saveProfileImage(image: image)
            ProfileImage.image = image
        }
        
        if (!success) {
            let alert = UIAlertController.init(title: "Save failed", message: "please try again", preferredStyle: .alert)
            let actionOK = UIAlertAction.init(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(actionOK);
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        let qrcodeScannerSDKViewController = QRCodeScannerSDKViewController.init(delegate: self, vibrate: true, codeType: QRCodeScannerSDKConstants_QR_CODE + QRCodeScannerSDKConstants_CRONTO_CODE, use: nil, scannerOverlay: true, scannerOverlayColor: nil)
        
        self.present(qrcodeScannerSDKViewController!, animated: true, completion: nil)
    }

    func qrCodeScannerSDKController(_ controller: QRCodeScannerSDKViewController!, didScanResult result: String!, withCodeType codeType: Int32) {
        
        var txt = result
        if let data = dataFromHexString(hexString: result), let str = String(data: data, encoding: String.Encoding.utf8) {
            txt = str
        }
        
//        if (codeType == QRCodeScannerSDKConstants_QR_CODE) {
//            scanResultType.text = "QRCode"
//        } else if (codeType == QRCodeScannerSDKConstants_CRONTO_CODE) {
//            scanResultType.text = "Color QR Code"
//        }
        
        controller.dismiss(animated: true, completion: {
            let alert = UIAlertController.init(title: nil, message:txt, preferredStyle: .alert);
            
            let actionOK = UIAlertAction.init(title: "OK", style: .default, handler:
            { action in
                alert.dismiss(animated: true, completion: nil);
            });
            
            alert.addAction(actionOK);
            self.present(alert, animated: true, completion: nil);
        })
    }
    
    func qrCodeScannerSDKControllerDidCancel(_ controller: QRCodeScannerSDKViewController!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrCodeScannerSDKController(_ controller: QRCodeScannerSDKViewController!, threwException exception: QRCodeScannerSDKException!) {
//        scanResultType.text = "Exception"
        scanResult.text = String(format:"Error Code : %@", exception.errorCode)
        scanResult.isHidden = false
    }
    
    func dataFromHexString(hexString: String) -> Data?
    {
        var hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: " ", with: "")
        hexString = hexString.lowercased();
        
        var data = Data(capacity: hexString.count / 2)
        
        for char in hexString.unicodeScalars
        {
            let c = char.value;
            
            if !((c >= 97 && c <= 102) || (c >= 48 && c <= 57))
            {
                return nil
            }
        }
        
        guard let regex = try? NSRegularExpression(pattern: "[0-9a-f]{2}", options: .caseInsensitive) else { return nil }
        
        regex.enumerateMatches(in: hexString, range: NSMakeRange(0, hexString.utf16.count))
        { match, flags, stop in
            let byteString = (hexString as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        return data
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
