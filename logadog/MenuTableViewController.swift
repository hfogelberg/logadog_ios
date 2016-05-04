//
//  MenuTableViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-04.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var MenuArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MenuTableViewController")
        
        MenuArray = ["Home", "Contacts", "Calendar"]
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
}
