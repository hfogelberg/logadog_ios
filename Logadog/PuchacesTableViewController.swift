//
//  PuchaceTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class PuchaceTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var purchaces = [PurchaceObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }
    
    override func viewWillAppear(animated: Bool) {
        getPurchases()
    }
    
    func getPurchases() {
        self.purchaces.removeAll()
        let route = "\(ROUTE_PURCHACE)"
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let purchaces = json["data"].array {
                for purchace in purchaces {
                    self.purchaces.append(PurchaceObject(json: purchace))
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
        return purchaces.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item = purchaces[indexPath.row]
        cell.textLabel!.text = item.object

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let id = indexPath.row
            self.deletePurchace(id)
        }
    }
    
    func deletePurchace(index: Int) {
        let item = purchaces[index]
        let message = "Do you want to delete \(item.object)?"
        let ac = UIAlertController(title: "Delete", message: message, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action) -> Void in
            let route = "\(ROUTE_PURCHACE)/\(item.id)"
            print(route)
            RestApiManager.sharedInstance.deleteRequest(route, onCompletion: {(json: JSON) -> () in
                var status = STATUS_OK
                
                if let statusVal = json["status"].numberValue as Int? {
                    status = statusVal
                }
                
                if status == STATUS_OK {
                    self.getPurchases()
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
}
