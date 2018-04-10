//
//  SettingViewController.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 9/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        let name = Utils.getName()
        nameTextField.text = name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // Create the AlertController
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "From URL", style: .default) { action -> Void in
            let alert = UIAlertController(title: "Enter image URL", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                
                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                    let urlString = alertTextField.text!
                    
                    let url = URL(string: urlString)
                    //let url = URL(string:"https://www.apple.com/v/home/dq/images/custom-heroes/product-red/hero_large.jpg")
                    if let data = try? Data(contentsOf: url!)
                    {
                        let image: UIImage = UIImage(data: data)!
                        Utils.saveSplashScreen(image: image)
                    }
                }
            }))
            
            alert.addTextField()
            self.present(alert, animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let takePictureAction = UIAlertAction(title: "From Gallery", style: .default) { action -> Void in
            
        }
        actionSheetController.addAction(takePictureAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
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
