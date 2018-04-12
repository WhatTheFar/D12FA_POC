//
//  SettingViewController.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 9/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ColorPickerDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleBarFontColorPicker: ColorPicker!
    @IBOutlet weak var titleBarColorPicker: ColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleBarFontColorPicker.colorSelectedDelegate = self
        titleBarColorPicker.colorSelectedDelegate = self
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        let name = Utils.getName()
        nameTextField.text = name
        
        let mainTabBarController = self.tabBarController as! MainTabBarViewController
        
        let titleBarColorHex = Utils.getTitleBarColor()
        let titleBarColor = titleBarColorPicker.select(hex: titleBarColorHex)
        mainTabBarController.setTitleBarColor(_color: titleBarColor)
        
        let titleBarFontColorHex = Utils.getTitleBarFontColor()
        let titleBarFontColor = titleBarFontColorPicker.select(hex: titleBarFontColorHex)
        mainTabBarController.setTitleBarFontColor(_color: titleBarFontColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorSelected(_ sender:ColorPicker, color: UIColor) {
        let mainTabBarController = self.tabBarController as! MainTabBarViewController

        if (sender == titleBarColorPicker){
            Utils.setTitleBarColor(newColor: color.hexString!)
            mainTabBarController.setTitleBarColor(_color: color)
        }
        else {
            Utils.setTitleBarFontColor(newColor: color.hexString!)
            mainTabBarController.setTitleBarFontColor(_color: color)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let newName = nameTextField.text
        Utils.setName(newName: newName!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func splashScreenChangeClick(_ sender: Any) {
        let button = sender as! UIButton
        
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        actionSheetController.popoverPresentationController?.sourceView = button
        actionSheetController.popoverPresentationController?.sourceRect = button.bounds
        
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
            success = Utils.saveSplashScreen(image: image)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
