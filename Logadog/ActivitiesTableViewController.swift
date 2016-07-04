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
    var petId = ""
    var activities = [ActivityObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getActivities()
    }

    func getActivities() {
        self.activities.removeAll()
        
        let route = "\(ROUTE_PETS)/\(self.petId)/\(ROUTE_ACTIVITY)"

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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "activitySegue" {
            let nextScene = segue.destinationViewController as! ActivityViewController
            nextScene.petId = self.petId
        } else if segue.identifier == "showActivitySegue" {
            let nextScene = segue.destinationViewController as! ActivityViewController
            nextScene.petId = self.petId
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Index: \(self.activities[indexPath.row])")
                let activity = self.activities[indexPath.row]
                nextScene.activity = activity
            }
        }
    }
}
