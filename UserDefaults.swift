//
//  UserDefaults.swift
//  ShoppingList
//
//  Created by Steven Shatz on 8/23/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

import Foundation
import UIKit

class UserDefaults {
    
    // Current color for each item in shoppingList can be an RGB color or a Pattern color (aka Texture)
    // In Standard User Defaults we save:
    //  - colorFlag: c=RGB color; t=texture (or Pattern color)
    //  - color: last color saved (defaults to white) -- UIColor
    //  - texture: name of last texture saved (defaults to last texture in textures array) - String
    
    
    var standardUserDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var colorType: String?       // c=RGB color, t=texture (aka: color Pattern)
    var colorName: String?       // description of RGB color or name of texture
    
    let defaultColor = Color(color: UIColor.whiteColor())
    
    
    init() {
        self.colorType = "c"
        self.colorName = defaultColor.colorName
    }

    
    func setUserDefaults(name: String!, colorType: String!, colorName:String!) {
        
        //println("Set: \(name): \(colorType)")
        
        if colorType != "c"  &&  colorType != "t" {
            self.colorType = "c"
            self.colorName = defaultColor.colorName
        } else {
            self.colorType = colorType
            self.colorName = colorName
        }
        
        var colorTypeData: NSData = NSKeyedArchiver.archivedDataWithRootObject(self.colorType!) as NSData
        var colorNameData: NSData = NSKeyedArchiver.archivedDataWithRootObject(self.colorName!) as NSData
        
        var userDefaultsDictionary: [String: NSData] = [
            "colorType" : colorTypeData,
            "colorName" : colorNameData
        ]
        
        var dictionaryData: NSData = NSKeyedArchiver.archivedDataWithRootObject(userDefaultsDictionary) as NSData
        
        let key: NSString = name + "Dictionary"
        
        self.standardUserDefaults.setObject(dictionaryData, forKey:key)
    }
    
 
    func getUserDefaults(name: String) -> Bool {
                
        if name == "" {
            return false
        }
        
        let key: NSString = name + "Dictionary"
        
        if self.standardUserDefaults.objectForKey(key) != nil {
            var dictionaryData: NSData = NSUserDefaults.standardUserDefaults().objectForKey(key) as NSData
        
            var userDefaultsDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(dictionaryData) as NSDictionary

            var colorTypeData: NSData = userDefaultsDictionary.valueForKey("colorType") as NSData
            var colorNameData: NSData = userDefaultsDictionary.valueForKey("colorName") as NSData

            self.colorType! = NSKeyedUnarchiver.unarchiveObjectWithData(colorTypeData) as String
            self.colorName! = NSKeyedUnarchiver.unarchiveObjectWithData(colorNameData) as String
            
//            println("Get: \(name): \(self.colorType), \(self.colorName)")
 
            return true
        } else {
            return false
        }
    }
    
        
    func syncUserDefaults() {
        self.standardUserDefaults.synchronize()
    }
    
    
}