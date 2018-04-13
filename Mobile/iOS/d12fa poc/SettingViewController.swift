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
    @IBOutlet weak var statusBarColorPicker: ColorPicker!
    
    @IBOutlet weak var tab1Icon: UIImageView!
    @IBOutlet weak var tab1Title: UITextField!
    
    @IBOutlet weak var tab2Icon: UIImageView!
    @IBOutlet weak var tab2Title: UITextField!
    
    var imagePickerMode = "none"
    var imagePickerIconIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleBarFontColorPicker.colorSelectedDelegate = self
        titleBarColorPicker.colorSelectedDelegate = self
        
        statusBarColorPicker.blackWhiteMode()
        statusBarColorPicker.colorSelectedDelegate = self
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tab1Title.delegate = self
        tab1Title.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tab2Title.delegate = self
        tab2Title.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.initTabIcon()
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
        
        if Utils.getStatusBarFontWhite() {
            let _ = statusBarColorPicker.select(hex: UIColor.white.hexString!)
        } else {
            let _ = statusBarColorPicker.select(hex: UIColor.black.hexString!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTabIcon() {
        
        let tabTitle = Utils.getTapTitle()
        for (index, view) in [tab1Title, tab2Title].enumerated() {
            view?.text = tabTitle[index]
        }
        
        for (index, view) in [tab1Icon, tab2Icon].enumerated() {
            
            if let icon = Utils.getTabIcon(tabIndex: index) {
                view?.backgroundColor = UIColor.white
                view?.image = icon
            } else {
                view?.backgroundColor = UIColor.lightGray
            }
            
            let g = UITapGestureRecognizer(target: self, action:  #selector (self.iconSelected (_:)))

            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(g)
        }
    }
    
    @objc func iconSelected(_ sender:UITapGestureRecognizer) {
        self.imagePickerMode = "icon"
        
        guard let selectedView = sender.view as? UIImageView else { return }
        
        if selectedView == tab1Icon {
            self.imagePickerIconIndex = 0
        } else {
            self.imagePickerIconIndex = 1
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

        
    func colorSelected(_ sender:ColorPicker, color: UIColor) {
        let mainTabBarController = self.tabBarController as! MainTabBarViewController

        if (sender == titleBarColorPicker){
            Utils.setTitleBarColor(newColor: color.hexString!)
            mainTabBarController.setTitleBarColor(_color: color)
        }
        else if(sender == titleBarFontColorPicker) {
            Utils.setTitleBarFontColor(newColor: color.hexString!)
            mainTabBarController.setTitleBarFontColor(_color: color)
        } else {
            mainTabBarController.setStatusBarFontWhite(isWhite: color.isLight)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let mainTabBarController = self.tabBarController as! MainTabBarViewController
        
        if textField == nameTextField {
            let newName = nameTextField.text
            Utils.setName(newName: newName!)
        } else {
            var tab1 = tab1Title.text
            var tab2 = tab2Title.text
            if tab1 == nil { tab1 = "" }
            if tab2 == nil { tab2 = "" }
            
            mainTabBarController.setTabTitle(tabName: [tab1!, tab2!])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func splashScreenChangeClick(_ sender: Any) {
        let button = sender as! UIButton
        
        self.imagePickerMode = "splashScreen"
        
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
        
        if self.imagePickerMode == "splashScreen" {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                success = Utils.saveSplashScreen(image: image)
            }
        }
        else if self.imagePickerMode == "icon" {
            let mainTabBarController = self.tabBarController as! MainTabBarViewController
            
            if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let icon = mainTabBarController.setTabIcon(tabIndex: self.imagePickerIconIndex, icon: image) {

                var view:UIImageView = tab1Icon
                if self.imagePickerIconIndex == 1 {
                    view = tab2Icon
                }
                
                view.backgroundColor = UIColor.white
                view.image = icon

                success = Utils.setTabIcon(tabIndex: self.imagePickerIconIndex, icon: icon)
            }
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
