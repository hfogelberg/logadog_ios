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
    var petId = ""
    var medications = [MedicationObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        getMedications()
    }
    
    func getMedications() {
        self.medications.removeAll()
        let route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_MEDICATION)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let medications = json["data"].array {
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

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let idx = indexPath.row
            deleteMedication(idx)
        }
    }

    func deleteMedication(index: Int) {
        let medication = medications[index]
        let message = "Do you want to delete \(medication.make)?"
        let ac = UIAlertController(title: "Delete", message: message, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            let route = "\(ROUTE_MEDICATION)/\(medication.medicationId)"
            RestApiManager.sharedInstance.deleteRequest(route, onCompletion: {(json: JSON) -> () in
                var status = STATUS_OK
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    self.getMedications()
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

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMedicationSegue" {
            let nextScene = segue.destinationViewController as! MedicationViewController
            nextScene.petId = self.petId
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("Index: \(self.medications[indexPath.row])")
                let medication = self.medications[indexPath.row]
                nextScene.medication = medication
            }
        } else if segue.identifier == "addMedicationSegue" {
            let nextScene = segue.destinationViewController as! MedicationViewController
            nextScene.petId = self.petId
        }
    }
}
