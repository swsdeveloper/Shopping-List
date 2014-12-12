//
//  Texture.swift
//  ShoppingList
//
//  Created by Steven Shatz on 8/23/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

import Foundation
import UIKit

class Texture {
    var name: String
    var imageName: String           // name + ".jpeg"
    var color: UIColor
    
    init(name: String) {
        self.name = name
        self.imageName = name + ".jpeg"
        self.color = UIColor(patternImage: UIImage(named: imageName)!)
    }
    
    func getName(color: UIColor) -> String {
        return self.name
    }
    
    
    // Generate Textures
    
    class func setupTextures() -> [Texture] {
        
        var textures: [Texture] = []    // array of all supported Textures
        
        let textureNames = [
            "bricks",
            "carnations",
            "diagonalStripes",
            "grass",
            "greenWeave",
            "metallic",
            "orangeFlame",
            "purpleSuns",
            "redDots",
            "redElephants",
            "starburst",
            "swimmingPool",
            "verticalStripes",
            "woodBlocks",
            "woodFloor"
        ]
        
        for tName in textureNames {
            textures.append(Texture(name: tName))
        }
        
        //for tName in textures { println(tName.imageName) }    // Un-Rem to print names of Textures in "textures" array
        
        return textures
    }
    
    class func getRandomTexture(textures: [Texture]) -> Texture {
        var items = CGFloat(textures.count)
        var randomTexture = CGFloat(drand48()) * items      // a float number between 0 and n
        var index = Int(randomTexture)                      // convert to integer: 0, 1, 2, ..., n
        return textures[index]
    }

    
}