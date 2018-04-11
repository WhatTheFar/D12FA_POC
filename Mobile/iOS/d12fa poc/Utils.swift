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
            name = "Mr. Somchai Krongkai"
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
