//
//  PetsTableViewController..swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class PetsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var pets = [PetObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.pets.removeAll()
        getDogs()
    }
    
    func getDogs() {
        let token = TokenController.getToken()
        let userId = TokenController.getUserId()
        
        self.pets.removeAll()
        
        if token != "" && userId != "" {
            RestApiManager.sharedInstance.getRequest(ROUTE_PETS, params: "") {(json:JSON) -> () in
                var status = STATUS_OK
                print(json)
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    if let pets = json["data"].array {
                        for pet in pets {
                            self.pets.append(PetObject(json: pet))
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tableView.reloadData()
                        })
                    }
                } else {
                    var message = ""
                    if let messageVal = json["message"].stringValue as String? {
                        message = messageVal
                    }

                    self.redirectToStart(message)
                }
            }
        } else {
            self.redirectToStart(MESSAGE_NO_TOKEN)
        }
    }

    func redirectToStart(message: String) {
        TokenController.removeTokenAndUser()
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.performSegueWithIdentifier("loginSegue", sender: self) })
            )
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        let pet = self.pets[indexPath.row]
        cell.textLabel!.text = pet.name
        cell.textLabel?.textColor = Colors.colorWithHexString(COLOR_TABLE_TEXT)
        return cell
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDogSegue" {
            let nextScene = segue.destinationViewController as! ShowDogViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let pet = self.pets[indexPath.row]
                nextScene.pet = pet
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
