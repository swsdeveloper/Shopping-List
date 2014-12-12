//
//  Color.swift
//  ShoppingList
//
//  Created by Steven Shatz on 8/25/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

import Foundation
import UIKit


class Color {
    
    var color: UIColor?
    var colorName: String?
    var contrastingColor: UIColor?

    
    // create a Random color object
    init() {
        let randomColor: UIColor = self.genRandomColor()
        let randomColorName: String = self.getColorNameFromColor(randomColor)
        let randomContrastingColor: UIColor = self.getContrastingColor(randomColor)
        self.color = randomColor
        self.colorName = randomColorName
        self.contrastingColor = randomContrastingColor
    }
    
    // create a color object from a specified color
    init(color:UIColor) {
        self.color = color
        let aColorName: String = self.getColorNameFromColor(color)
        let aContrastingColor: UIColor = self.getContrastingColor(color)
        self.colorName = aColorName
        self.contrastingColor = aContrastingColor
    }

    // create a color object from a specified colorName
    init(colorName:String) {
        self.colorName = colorName
        let aColor: UIColor = self.getColorFromColorName(colorName)
        let aContrastingColor: UIColor = self.getContrastingColor(aColor)
        self.color = aColor
        self.contrastingColor = aContrastingColor
    }

    
     private func genRandomColor() -> UIColor {
        var randomRed:CGFloat = CGFloat(drand48())      // returns random decimal number between 0.0 and 1.0, inclusive
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        var randomAlpha:CGFloat = 1.0                   // (for possible future use)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: randomAlpha)
    }
 
    
    private func getColorNameFromColor(color: UIColor) -> String {
        let colorComponents = CGColorGetComponents(color.CGColor)                 // returns array of CGFloat objects
        let red = colorComponents[0]
        let green = colorComponents[1]
        let blue = colorComponents[2]
        //let alpha = colorComponents[3]
        let colorName = "\(red)+\(green)+\(blue)"
        return colorName
    }
    
    // Convert color named "0.12231+0.123123+0.123132" into an RGB UIColor

    private func getColorFromColorName(colorName: String) -> UIColor {
        
        let rgbArray = split(colorName, { $0 == "+"}, maxSplit: Int.max, allowEmptySlices: false)   // creates [String]
        
        if rgbArray.count < 3 {                                     // Should never happen
            return UIColor.grayColor()
        }
        
        let redAsNSString = NSString(string: rgbArray[0])           // converts String to NSString
        let greenAsNSString = NSString(string: rgbArray[1])
        let blueAsNSString = NSString(string: rgbArray[2])
        
        let red = CGFloat(redAsNSString.doubleValue)                // converts NSString to Double to CGFloat
        let green = CGFloat(greenAsNSString.doubleValue)
        let blue = CGFloat(blueAsNSString.doubleValue)
        
        //        println("\(red)")
        //        println("\(green)")
        //        println("\(blue)")
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    
    // Choose appropriate text color based on background color
    
    private func getContrastingColor(color: UIColor) -> UIColor {
        
        let colors = CGColorGetComponents(color.CGColor)    // returns array of CGFloat objects
        
        //        println(colors[0])    //red
        //        println(colors[1])    //green
        //        println(colors[2])    //blue
        //        println(colors[3])    //alpha
        
        let brightness: Int = brightnessOfColor(colors[0], green: colors[1], blue: colors[2])
        
        //        println(brightness)
        //        println()
        
        let threshold: Int = 130
        let contrastingColor: UIColor = (brightness < threshold) ? UIColor.whiteColor() : UIColor.blackColor()
        
        return contrastingColor
    }
    
    private func brightnessOfColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> Int {
        //brightness  =  sqrt( .241 Red*Red + .691 Green*Green + .068 Blue*Blue ) -- returns 0 to 255
        let red1 = red * 255.0
        let green1 = green * 255.0
        let blue1 = blue * 255.0
        let red2 = red1 * red1 * 0.241
        let green2 = green1 * green1 * 0.691
        let blue2 = blue1 * blue1 * 0.068
        let sum = Double(red2 + green2 + blue2)
        let brightness = Int(sqrt(sum))
        return brightness
    }
    
}


