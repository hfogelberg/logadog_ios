//
//  ActivitiesTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivitiesTableViewController: UITableViewController {
    var pet:PetObject!
    var activities = [ActivityObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getActivities()
    }

    func getActivities() {
        self.activities.removeAll()
        
        let route = "\(ROUTE_PETS)/\(self.pet.id)/\(ROUTE_ACTIVITY)"

        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let activities = json["data"].array {
                for activity in activities {
                    self.activities.append(ActivityObject(json: activity))
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })
            }
        })
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let activity = self.activities[indexPath.row]
        cell.textLabel!.text = activity.activityType
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let id = indexPath.row
            self.deleteActivity(id)
        }
    }
    
    func deleteActivity(index: Int) {
        let activity = activities[index]
        let message = "Do you want to delete \(activity.activityType)?"
        let ac = UIAlertController(title: "Delete", message: message, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            let route = "\(ROUTE_PETS)/\(ROUTE_ACTIVITY)/\(activity.activityId)"
            RestApiManager.sharedInstance.deleteRequest(route, onCompletion: {(json: JSON) -> () in
                var status = STATUS_OK
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    self.getActivities()
                } else {
                    var message = ""
                    if let messageVal = json["message"].stringValue as String? {
                        message = messageVal
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Cacel", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        presentViewController(ac, animated: true, completion: nil)
    }

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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "activitySegue" {
            let nextScene = segue.destinationViewController as! ActivityViewController
            nextScene.pet = self.pet
        } else if segue.identifier == "showActivitySegue" {
            let nextScene = segue.destinationViewController as! ActivityViewController
            nextScene.pet = self.pet
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Index: \(self.activities[indexPath.row])")
                let activity = self.activities[indexPath.row]
                nextScene.activity = activity
            }
        }
    }
}
