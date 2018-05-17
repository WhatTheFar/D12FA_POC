//
//  Utils.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 9/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import Foundation

class Utils {
    
    static func getName() -> String {
        let defaults = UserDefaults.standard
        var name:String? = defaults.string(forKey: "name")
        if (name == nil) {
            name = "Mr. CODIUM"
            defaults.set(name, forKey: "name")
        }
        
        return name!;
    }

    static func setName(newName:String) {
        let name = Utils.getName()
        
        guard name != newName else {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(newName, forKey: "name")
    }

    static func getTitleBarColor() -> String {
        let defaults = UserDefaults.standard
        var color:String? = defaults.string(forKey: "titleBarColor")
        if (color == nil) {
            color = UIColor.white.hexString
            defaults.set(color, forKey: "titleBarColor")
        }
        
        return color!;
    }
    
    static func setTitleBarColor(newColor:String) {
        let color = Utils.getTitleBarColor()
        
        guard color != newColor else {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(newColor, forKey: "titleBarColor")
    }

    static func getTitleBarFontColor() -> String {
        let defaults = UserDefaults.standard
        var color:String? = defaults.string(forKey: "titleBarFontColor")
        if (color == nil) {
            color = UIColor.black.hexString
            defaults.set(color, forKey: "titleBarFontColor")
        }
        
        return color!;
    }
    
    static func setTitleBarFontColor(newColor:String) {
        let color = Utils.getTitleBarFontColor()
        
        guard color != newColor else {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(newColor, forKey: "titleBarFontColor")
    }
    
    static func setTapTitle(tap:Array<String>) {
        let defaults = UserDefaults.standard
        defaults.set(tap, forKey: "tapTitle")
    }
    
    static func getTapTitle() -> Array<String> {
        let defaults = UserDefaults.standard
        var title:Array<String>? = defaults.stringArray(forKey: "tapTitle")
        
        if title == nil {
            title = ["Main", "Customize"]
            defaults.set(title, forKey: "tapTitle")
        }
        
        return title!;
    }
    
    static func setStatusBarFontWhite(isWhite: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isWhite, forKey: "statusBarFontWhite")
    }

    static func getStatusBarFontWhite() -> Bool {
        let defaults = UserDefaults.standard
        let isWhite:Bool = defaults.bool(forKey: "statusBarFontWhite")
        
        return isWhite;
    }
    
    static func setTabIcon(tabIndex: Int, icon: UIImage) -> Bool {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = String(format:"icon_%d.png", tabIndex)
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        
        let filePath = fileUrl.path
        if (FileManager.default.fileExists(atPath: filePath)) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
        
        do {
            try UIImagePNGRepresentation(icon)?.write(to: fileUrl, options: .atomic)
        }
        catch {
            print("Unexpected non-vending-machine-related error: \(error)")
            return false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(fileName, forKey: String(format:"iconFileName_%d", tabIndex))
        
        return true
    }
    
    static func getTabIcon(tabIndex:Int) -> UIImage? {
        let defaults = UserDefaults.standard
        
        guard let fileName = defaults.string(forKey: String(format:"iconFileName_%d", tabIndex)) else { return nil }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }
        
        let image = UIImage(data: data)
        return image;
    }
    
    static func saveProfileImage(image:UIImage) -> Bool {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileUrl = documentDirectory.appendingPathComponent("profileImg.jpg")
        
        let filePath = fileUrl.path
        if (FileManager.default.fileExists(atPath: filePath)) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
        
        //try? UIImagePNGRepresentation(image)?.write(to: fileUrl, options: .atomic)
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: fileUrl, options: .atomic)
        }
        catch {
            print("Unexpected non-vending-machine-related error: \(error)")
            return false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(filePath, forKey: "profileImg")
        
        return true
    }
    
    static func getProfileImage() -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileUrl = documentDirectory.appendingPathComponent("profileImg.jpg")
        
        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }
        
        let image = UIImage(data: data)
        return image;
    }
    
    static func saveSplashScreen(image:UIImage) -> Bool {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileUrl = documentDirectory.appendingPathComponent("splash.jpg")
        
        let filePath = fileUrl.path
        if (FileManager.default.fileExists(atPath: filePath)) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
        
        //try? UIImagePNGRepresentation(image)?.write(to: fileUrl, options: .atomic)
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: fileUrl, options: .atomic)
        }
        catch {
            print("Unexpected non-vending-machine-related error: \(error)")
            return false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(filePath, forKey: "splashScreen")
        
        return true
    }
    
    static func getSplashScreen() -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileUrl = documentDirectory.appendingPathComponent("splash.jpg")

        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }
        
        let image = UIImage(data: data)
        return image;
    }
}
