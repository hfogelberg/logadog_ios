    //
//  MenuTableViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-04.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MenuTableViewController: UITableViewController {
    
    var MenuArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MenuTableViewController")
        
        MenuArray = ["Home", "Contacts", "Calendar", "Diary", "Sign Out"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = MenuArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case MENU_HOME:
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("dogsListSegue", sender: self)
                }
            case MENU_CONTACTS:
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("contactsListSegue", sender: self)
                }
            case MENU_CALENDAR:
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("dogsListSegue", sender: self)
                }
            case MENU_SIGN_OUT:
                KeychainWrapper.removeObjectForKey(KEYCHAIN_TOKEN)
                KeychainWrapper.removeObjectForKey(KEYCHAIN_USER)
            default:
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("dogsListSegue", sender: self)
            }
        }
    }
}

