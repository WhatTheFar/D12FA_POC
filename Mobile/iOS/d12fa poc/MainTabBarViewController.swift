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

        self.setTitleBarFontColor(_color: UIColor(hex: Utils.getTitleBarFontColor()))
        self.setTitleBarColor(_color: UIColor(hex: Utils.getTitleBarColor()))
        self.initTabIcon()
        self.setTabTitle(tabName: Utils.getTapTitle())
        self.setStatusBarFontWhite(isWhite: Utils.getStatusBarFontWhite())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTabTitle(tabName: Array<String>)
    {
        Utils.setTapTitle(tap: tabName)
        
        guard let viewControllers = self.viewControllers else { return }
        
        for (index, viewController) in viewControllers.enumerated() {
            //set title
            viewController.title = tabName[index]

            //set title of child inside tab
            guard let navigationController = viewController as? UINavigationController else { continue }

            for childViews in navigationController.viewControllers {
                childViews.navigationItem.title = tabName[index]
            }
        }
    }
    
    func initTabIcon() {
        guard let viewControllers = self.viewControllers else { return }
        
        for (index, _) in viewControllers.enumerated() {
            guard let icon = Utils.getTabIcon(tabIndex: index) else { continue }
            
            let _ = self.setTabIcon(tabIndex: index, icon: icon)
        }
    }

    func setTabIcon(tabIndex:Int, icon:UIImage) -> UIImage? {
        guard let viewControllers = self.viewControllers else { return nil }
        
        let viewController = viewControllers[tabIndex]
        
        guard let navigationController = viewController as? UINavigationController else { return nil }
        
        var width = 15.0
        var height = 15.0
        
        if UIScreen.main.scale == 2 {
            width = 30.0
            height = 30.0
        } else {
            width = 60.0
            height = 60.0
        }
        
        let scaleW = icon.size.width / CGFloat(width)
        let scaleH = icon.size.height / CGFloat(height)
        var scale = scaleW
        
        if scaleH > scale {
            scale = scaleH
        }
        
        let scaleIcon = UIImage(cgImage: icon.cgImage!, scale: scale, orientation: icon.imageOrientation)

        for childViews in navigationController.viewControllers {
            childViews.tabBarItem.image = scaleIcon //.withRenderingMode(.alwaysOriginal)
            childViews.tabBarItem.selectedImage = scaleIcon //.withRenderingMode(.alwaysOriginal)
        }
        
        if let items = self.tabBar.items {
            let item = items[tabIndex]
            item.image = scaleIcon //.withRenderingMode(.alwaysOriginal)
            item.selectedImage = scaleIcon //.withRenderingMode(.alwaysOriginal)
        }
        
        return icon
    }

    func setStatusBarFontWhite(isWhite:Bool) {
        if isWhite {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        
        Utils.setStatusBarFontWhite(isWhite: isWhite)
    }
    
    func setTitleBarFontColor(_color: UIColor?) {
        guard let color = _color else { return }
        
        if let items = self.tabBar.items {
            for item in items {
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .selected)
            }
        }
        
        //set globally, restart app required
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color], for: .selected)
        
        self.tabBar.tintColor = color
        self.tabBar.unselectedItemTintColor = color

        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                guard let navigationController = viewController as? UINavigationController else { continue }
                
                //set color
                navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
            }
        }
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
        
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                guard let navigationController = viewController as? UINavigationController else { continue }
                
                //set color
                navigationController.navigationBar.barTintColor = color
                navigationController.navigationBar.isTranslucent = true
            }
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
