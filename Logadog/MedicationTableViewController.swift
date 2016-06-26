//
//  MedicationTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-02.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class MedicationTableViewController: UITableViewController {
    var dogId = ""
    var medications = [MedicationObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        getMedications()
    }
    
    func getMedications() {
        self.medications.removeAll()
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_MEDICATION)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            print(json)
            if let medications = json.array {
                for medication in medications {
                    self.medications.append(MedicationObject(json: medication))
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
        return self.medications.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let medication = self.medications[indexPath.row]
        cell.textLabel!.text = medication.productType

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
        if segue.identifier == "showMedicationSegue" {
            let nextScene = segue.destinationViewController as! MedicationViewController
            nextScene.dogId = self.dogId
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Index: \(self.medications[indexPath.row])")
                let medication = self.medications[indexPath.row]
                nextScene.medication = medication
            }
        } else if segue.identifier == "addMedicationSegue" {
            let nextScene = segue.destinationViewController as! MedicationViewController
            nextScene.dogId = self.dogId
        }
    }
}
