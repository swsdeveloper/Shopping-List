//
//  ItemViewController.swift
//  ShoppingList
//
//  Created by Oren Goldberg on 8/18/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    
    // The next 4 items are set by ListTableViewController before pushing this view

    var existingItem:NSManagedObject!
    
    var name: String = ""
    var quantity: String = ""
    var info: String = ""
    
    
    //Colors
    
    var colorArray: [UIColor] = []
    var colorNameArray: [String] = []
    
    var defaultColor: Color?

    var color: UIColor?

    
    //Textures
    
    var textureNames: [String] = []
    var textures: [Texture] = []        // Array of all textures

    var textureArray: [Texture] = []    // User-selected textures
    var texture: Texture?


    // User Defaults
    
    var userDefaults = UserDefaults()
    
    var colorType: String?
    var colorName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
        quantityTextField.delegate = self
        infoTextField.delegate = self
        
        if name == "" {
            nameTextField.becomeFirstResponder()    // set initial focus in Name field (only if this is an "add" operation)
        }
        
        // Set up Colors
        
        defaultColor = Color(color:UIColor.whiteColor())
        
        color = defaultColor!.color
        
        colorType = "c"
        colorName = defaultColor!.colorName
        
        if colorArray.count < 1 {
            colorArray.append(defaultColor!.color!)
            colorNameArray = [defaultColor!.colorName!]
        }


        // Set up Textures
        
        textures = Texture.setupTextures()          // textures is array containing all supported Textures
        
       
        if existingItem != nil {
            nameTextField.text = self.name
            quantityTextField.text = self.quantity
            infoTextField.text = self.info
        }
        
        
        if userDefaults.getUserDefaults(self.name) == true {
            colorType = userDefaults.colorType
            colorName = userDefaults.colorName
            
            if self.colorType == "t" {
                texture = Texture(name: colorName!)
                color = texture!.color
            } else {
                color = Color(colorName: colorName!).color
                colorArray.append(color!)
                colorNameArray.append(colorName!)
            }
            
        } else {
            colorType = "c"
            colorName = defaultColor!.colorName
            color = defaultColor!.color
        }
        
        self.view.backgroundColor = color
        
        
        // Register which Swipe Gestures this view will recognize:
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)        
    }
    

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
                case UISwipeGestureRecognizerDirection.Right:
//                    println("Swiped right")
                    //move forward thru color array
                    
                    var randomColor = Color()
                    
                    colorType = "c"
                    color = randomColor.color!
                    colorName = randomColor.colorName!
                    
                    self.view.backgroundColor = color
                    
                    colorArray.append(color!)
                    colorNameArray.append(colorName!)
                
                case UISwipeGestureRecognizerDirection.Left:
//                    println("Swiped left")
                    //move backwards thru color array
                
                    if colorArray.count > 1 {           // Can't go backwards if there is only 1 color
                                                        // (note: 1st color in colorArray is the default color)
                        let deletedColor = colorArray.removeLast()
                        let deletedColorName = colorNameArray.removeLast()
                        
                        colorType = "c"
                        color = colorArray.last!
                        colorName = colorNameArray.last!
                        
                        self.view.backgroundColor = color
                    }
   
                
                case UISwipeGestureRecognizerDirection.Down:
//                    println("Swiped down")
                    //move forward thru texture array (aka: color pattern images)

                    var newTexture = Texture.getRandomTexture(textures)
                    
                    colorType = "t"
                    color = newTexture.color
                    colorName = newTexture.name
                    
                    self.view.backgroundColor = newTexture.color
                
                    textureArray.append(newTexture)
                

                case UISwipeGestureRecognizerDirection.Up:
//                    println("Swiped Up")
                    //move backwards thru texture array

                    if textureArray.count > 1 {                         // Can't go backwards if there is only 1 texture
                        let deletedTexture = textureArray.removeLast()
                        texture = textureArray.last
                        colorType = "t"
                        color = texture!.color
                        colorName = texture!.name
                        self.view.backgroundColor = color
                        
                    } else if textureArray.count == 1 {                 // color array never removes 1st item (i.e., the default color)
                        let deletedTexture = textureArray.removeLast()
                        colorType = "c"
                        color = colorArray.last
                        colorName = colorNameArray.last!
                        self.view.backgroundColor = color
                    }
 
                default:
                    break
                
            }// end of switch stmt
        }// end of if stmt
    }// end of function

    
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
    
        if existingItem != nil {                                                                   // item exists - update it
            
            //save updated properties (if any)
            
            existingItem.setValue(nameTextField.text as String, forKey: "name")
            existingItem.setValue(quantityTextField.text as String, forKey: "quantity")
            existingItem.setValue(infoTextField.text as String, forKey: "info")
            
            //save updated color (if any)
            
            userDefaults.setUserDefaults(nameTextField.text,
                                        colorType: colorType,
                                        colorName: colorName)
            
        } else if nameTextField.text == "" && quantityTextField.text == "" && infoTextField.text == "" {
            
            //navigate back to root vc
            
            self.navigationController!.popToRootViewControllerAnimated(true)                         // nothing entered - no change - POP back to root view controller
            
        } else {                                                                                    // this is a new item - add it
            //create instance of data model and initialize
            
            var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
            
            //map input to item properties
            
            newItem.name = self.nameTextField.text
            newItem.quantity = self.quantityTextField.text
            newItem.info = self.infoTextField.text
            
            //save newly selected color (if any)
            
            userDefaults.setUserDefaults(newItem.name,
                                        colorType: colorType,
                                        colorName: colorName)
        }
        
        //save context - for both update and add
        contxt.save(nil)
        
        //save user defaults - for both update and add
        userDefaults.syncUserDefaults()
        
        //navigate back to root vc
        self.navigationController!.popToRootViewControllerAnimated(true)     // forces a POP back to root view controller after update or add
    }
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController!.popToRootViewControllerAnimated(true)     // if cancel button was pressed, don't save anything - just POP back
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true
    }
}
