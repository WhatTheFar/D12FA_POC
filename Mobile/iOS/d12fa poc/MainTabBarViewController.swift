//
//  MainTabBarViewController.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 11/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        self.setTitleBarFontColor(_color: UIColor(hex: Utils.getTitleBarFontColor()))
        self.setTitleBarColor(_color: UIColor(hex: Utils.getTitleBarColor()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitleBarFontColor(_color: UIColor?) {
        guard let color = _color else { return }
        
        guard let items = self.tabBar.items else { return }
        
        for item in items {
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .normal)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .selected)
        }

        //set globally, restart app required
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .selected)
    }
    
    func setTitleBarColor(_color: UIColor?) {
        guard let color = _color else { return }
        
        self.tabBar.barTintColor = color;
        
        //set globally, restart app required
        //UITabBar.appearance().barTintColor = color
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
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
