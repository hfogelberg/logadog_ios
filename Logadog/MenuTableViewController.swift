//
//  MenuTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-22.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    let menuItems = ["Home", "Contacts", "Calendar", "Purchases", "Diary", "Photos", "Walks", "Settings", "Sign out"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let item = menuItems[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == MENU_HOME {
            performSegueWithIdentifier("dogsListSegue", sender: nil)
        }
        else if indexPath.row == MENU_CONTACTS {
            performSegueWithIdentifier("contactsSegue", sender: nil)
        }
    }
}
