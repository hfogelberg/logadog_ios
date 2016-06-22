//
//  DogsTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class DogsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var dogs = [DogObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.dogs.removeAll()
        getDogs()
    }
    
    func getDogs() {
        print("getDogs")
        let token = TokenController.getToken()
        let userId = TokenController.getUserId()
        
        self.dogs.removeAll()
        
        if token != "" && userId != "" {
            let params = "userid=\(userId)&token=\(token)"
            print(params)
            RestApiManager.sharedInstance.getRequest(ROUTE_DOGS, params: params) {(json:JSON) -> () in
                var status = STATUS_OK
                if let statusVal = json["status"].rawString() as String? {
                    status = Int(statusVal)!
                }
                
                if status == STATUS_OK {
                    if let dogs = json["dogs"].array {
                        for dog in dogs {
                            self.dogs.append(DogObject(json: dog))
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.tableView.reloadData()
                        })
                    }
                } else {
                    self.redirectToStart(status)
                }
            }
        } else {
            self.redirectToStart(STATUS_NO_TOKEN)
        }
    }

    func redirectToStart(statusCode: Int) {
        print("Invalid token or some error. Redirect to Start")
        TokenController.removeTokenAndUser()
        let message = ErrorMessages.messageForErrorCode(statusCode)
        
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
        return self.dogs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        let dog = self.dogs[indexPath.row]
        cell.textLabel!.text = dog.name
        cell.textLabel?.textColor = Colors.colorWithHexString(COLOR_TABLE_TEXT)
        return cell
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for segue")
        if segue.identifier == "showDogSegue" {
            let nextScene = segue.destinationViewController as! ShowDogViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Index: \(self.dogs[indexPath.row])")
                let dog = self.dogs[indexPath.row]
                nextScene.dog = dog
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
