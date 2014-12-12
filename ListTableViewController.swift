//
//  ListTableViewController.swift
//  ShoppingList
//
//  Created by Oren Goldberg on 8/18/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    var myList :Array<AnyObject> = []
    
    var userDefaults = UserDefaults()
    
    
    
    // var statusLabel: UILabel?

    
    @IBOutlet var navItem: UINavigationItem!
    
    @IBOutlet var searchTextField: UITextField!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations (however, at the moment, selections are not highlighted)
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchTextField.delegate = self
        
        
        // ***** SPECIAL CODE FOR TESTING PURPOSES ONLY:  Normally both lines should be commented out **************************************

        //genTestData()         // Print current data to console in a form that can be inserted into the loadTestData() function
        
        //loadTestData()        // Load initial set of data for testing purposes ...
        
        // *********************************************************************************************************************************
        
    }
    
    override func viewDidAppear(animated: Bool) {

        searchTextField.text = ""
        
//        searchTextField.becomeFirstResponder()  // set initial focus on search field (useful for testing in simulator; not good for iPhone)

        fetchCoreData("")
        
        tableView.reloadData()
        
        // Uncomment either of the following lines to see the contents of the Managed Object Model.
        // println("\( ( (UIApplication.sharedApplication().delegate) as AppDelegate).managedObjectContext!.persistentStoreCoordinator!.managedObjectModel )")
        // println("\( context.persistentStoreCoordinator!.managedObjectModel )")
        
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let CellID: NSString = "Cell"
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellID) as UITableViewCell
        
        // Configure the cell...
        
        let ip = indexPath
        
        //      The following code was replaced with a simpler method (immed. below it):
        //         var data: NSManagedObject = myList[ip.row] as NSManagedObject
        //         cell.textLabel.text = data.valueForKeyPath("name") as String
        //         var qnt = data.valueForKeyPath("quantity") as String
        //         var inf = data.valueForKeyPath("info") as String
        
        var data: Model = myList[ip.row] as Model

        var nam = data.name as String
        var qnt = data.quantity as String
        var inf = data.info as String
 
        cell.textLabel.text = nam
        
        // Set "detailTextLabel - a subtitle of the cell's textLabel - see storyboard
        if (qnt.toInt() != 1) {
            cell.detailTextLabel!.text = "\(qnt) items  \(inf)"
        } else {
            cell.detailTextLabel!.text = "\(qnt) item  \(inf)"
        }
        
        if userDefaults.getUserDefaults(nam) == true {
            var colorType = userDefaults.colorType!
            var colorName = userDefaults.colorName!
            
            if colorType == "t" {
                let userTexture = Texture(name: colorName)
                cell.backgroundColor = userTexture.color
                cell.textLabel.textColor = UIColor.yellowColor()
                cell.detailTextLabel!.textColor = UIColor.yellowColor()
                cell.textLabel.backgroundColor = UIColor.clearColor()
                cell.detailTextLabel!.backgroundColor = UIColor.clearColor()
            } else {                                                // We only come here when colorType = "c"
                let userColor = Color(colorName: colorName)
                cell.backgroundColor = userColor.color
                cell.textLabel.textColor = userColor.contrastingColor!
                cell.detailTextLabel!.textColor = userColor.contrastingColor!
            }
            
        } else {
            let userColor = Color(color: UIColor.whiteColor())
            cell.backgroundColor = userColor.color
            cell.textLabel.textColor = userColor.contrastingColor!
            cell.detailTextLabel!.textColor = userColor.contrastingColor!
        }
        
        return cell
    }

    
    // Override to support conditional editing of the table view (i.e., you can make some rows non-editable)
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        if editingStyle == .Delete {
            
            let tv = tableView
            
            // Delete the row from the data source
            context.deleteObject(myList[indexPath.row] as NSManagedObject)              // 1. Delete object from Context
            
            myList.removeAtIndex(indexPath.row)                                         // 2. Delete object from List that feeds Context and Table
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)     // 3. Delete object from Table
            
            /* NOTE: XCODE 6 BETA 6 - LINKER ERROR:
                Undefined symbols for architecture x86_64:  "__TFSs15_arrayForceCastU___FGSaQ__GSaQ0__"
                WHEN NO EXCLAMATION AFTER "indexPath" -- WHY ????
            */

            
            var error: NSError? = nil
            
            if !context.save(&error) {
                abort()
            }
            
            showHitCount()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //
        // UITableView's indexPathForSelectedRow() function returns the current row
        //   (i.e., the row containing the ">" that the user tapped on, which in turn triggered this segue)
        
        if segue.identifier == "update" {
            if self.tableView.indexPathForSelectedRow() != nil {
                var selectedItem: NSManagedObject = myList[self.tableView.indexPathForSelectedRow()!.row] as NSManagedObject
            
                let itemViewController: ItemViewController = segue.destinationViewController as ItemViewController
            
                itemViewController.name = selectedItem.valueForKey("name") as String
                itemViewController.quantity = selectedItem.valueForKey("quantity") as String
                itemViewController.info = selectedItem.valueForKey("info") as String
            
                itemViewController.existingItem = selectedItem
            }
        }
    }
    
    
    // Does a Core Data fetch with an optional search string, setting myList to the results
    func fetchCoreData(searchArg: String?) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: "localizedCaseInsensitiveCompare:" )

        let fetchRequest = NSFetchRequest(entityName: "List")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "!(name contains[cd] %@)", "")

        if searchArg != nil && searchArg != "" {
            
            let predicate: NSPredicate = NSPredicate(format: "(name contains[cd] %@) or (quantity contains[cd] %@) or (info contains[cd] %@)", searchArg!, searchArg!, searchArg!)!
            
            fetchRequest.predicate = predicate
        }
        
        myList = context.executeFetchRequest(fetchRequest, error: nil)!
        
        showHitCount()
    }

    
    func showHitCount() {
        var hitCount: String = ""
        
        if myList.count > 1 {
            hitCount = "\(myList.count) items"
        } else if myList.count == 1 {
            hitCount = "1 item"
        } else {
            hitCount = "No Items"
        }
  
        navItem.prompt = hitCount
        
        //statusLabel!.text = hitCount
    }
 
    
    
    func genTestData() {
        for item in myList {
            var itemx = item as Model
            println("addToMyList(\"\(itemx.name)\", quantity:\"\(itemx.quantity)\",info:\"\(itemx.info)\")")
        }
    }
    
    func loadTestData() {
        addToMyList("apples", quantity:"200",info:"Empire")
        addToMyList("avocados", quantity:"24",info:"not yet ripe, greenish black")
        addToMyList("bananas", quantity:"40 bunches",info:"ripe yellow")
        addToMyList("bumbershoots", quantity:"120 packages",info:"new Japanese umbrella-like vegetable")
        addToMyList("candy", quantity:"50 boxes",info:"orange chocolate")
        addToMyList("carrots", quantity:"66 bunches",info:"Fresh, organic, orange")
        addToMyList("cucumbers", quantity:"55",info:"Kirby")
        addToMyList("eggs", quantity:"100 dozen",info:"brown, grade A, large")
        addToMyList("eggs", quantity:"77 dozen",info:"organic, white, small")
        addToMyList("eggs", quantity:"40 dozen",info:"organic, brown, grade A+, large")
        addToMyList("eggs", quantity:"200 dozen",info:"grade A+, brown")
        addToMyList("grapes", quantity:"10 bunches",info:"red seedless")
        addToMyList("lemons", quantity:"30",info:"yellow and sweet")
        addToMyList("lettuce", quantity:"20 heads",info:"Butterhead")
        addToMyList("lettuce", quantity:"30",info:"Bibb")
        addToMyList("lettuce", quantity:"50 bags",info:"Mesclun")
        addToMyList("lettuce", quantity:"233 heads",info:"iceberg - boring and green")
        addToMyList("limes", quantity:"40",info:"green and sweet")
        addToMyList("oranges", quantity:"222",info:"Sunkist ")
        addToMyList("pears", quantity:"77",info:"Bosc")
        addToMyList("sopprosata", quantity:"2 packs",info:"spicy separately presliced")
        addToMyList("squash", quantity:"30",info:"green and yellow, slim")
        addToMyList("tomatoes", quantity:"140",info:"red grape")
        addToMyList("umbrellas", quantity:"10",info:"black expanding minis")
    }

    func addToMyList(name: String, quantity: String, info: String) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let contxt: NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("List", inManagedObjectContext: contxt)
        
        var newItem = Model(entity: en!, insertIntoManagedObjectContext: contxt)
        newItem.name = name
        newItem.quantity = quantity
        newItem.info = info
        
        contxt.save(nil)
    }
    

    // MARK: UITextFieldDelegate - The text field calls this method whenever the user types a new character in the text field or deletes an existing character.
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
            // return NO to not change text to what user just typed

        let currentText = textField.text as NSString?   // this is data that was in field before user's latest keystroke
        
        var srchArg = currentText?.stringByReplacingCharactersInRange(range, withString: string)
        
//        println("Current Text: \(currentText)")
//        println("New Text: \(srchArg)")
        
        fetchCoreData(srchArg)
        
        tableView.reloadData()
        
        return true                     // if this is set to false, nothing is echoed in text field
    }
 
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true
    }

    

    
}
