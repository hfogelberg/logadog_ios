//
//  ContactsTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-22.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactsTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var contacts = [ContactObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }
    
    override func viewDidAppear(animated: Bool) {
        getContacts()
    }
    
    func getContacts() {
        self.contacts.removeAll()
        let route = "\(ROUTE_CONTACT)"
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let contacts = json["data"].array {
                for contact in contacts {
                    self.contacts.append(ContactObject(json: contact))
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
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let contact = contacts[indexPath.row]
        cell.textLabel!.text = contact.name

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let idx = indexPath.row
            deleteContact(idx)
        }
    }
    
    func deleteContact(index: Int) {
        let contact = contacts[index]
        let message = "Do you want to delet \(contact.name)?"
        let ac = UIAlertController(title: "Delete", message: message, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            let route = "\(ROUTE_CONTACT)/\(contact.id)"
            RestApiManager.sharedInstance.deleteRequest(route, onCompletion: {(json: JSON) -> () in
                var status = STATUS_OK
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    self.getContacts()
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
        if segue.identifier == "showContactSegue" {
            let nextScene = segue.destinationViewController as! ContactViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contactId = self.contacts[indexPath.row].id
                nextScene.contactId = contactId
            }
        }
    }
}
