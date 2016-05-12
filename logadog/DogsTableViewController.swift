//
//  DogsTableViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-10.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class DogsTableViewController: UITableViewController, DogControllerProtocol, APIControllerProtocol {
    var tokenApi : APIController?
    var api : DogController?
    var dogs: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To be on the safe side check that there's a valid token
        if TokenController.hasToken() {
            checkValidToken()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
        
        view.backgroundColor = Colors().backgoundColor()
        getDogs()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated) 
        getDogs()
    }
    
    func checkValidToken() {
        if let token = TokenController.getToken() {
            // There is a token. Check with the server that it's valid
            let postString = "token=\(token)"
            self.tokenApi = APIController(delegate: self)
            self.tokenApi!.getJson(postString, route: ROUTE_CHECK_TOKEN)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    
    func didRecieveAPIResults(status: Int, message: String, results: NSDictionary) {
        if status == FALSE {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            alert.addAction(okAction)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getDogs() {
        print("getDogs")
        let token = TokenController.getToken() as String!
        let userId = TokenController.getUserId() as String!
        
        let params = "token=\(token)"
        
        self.api = DogController(delegate: self)
        self.api!.getDogsArray(params, route: ROUTE_DOGS + "/\(userId)")
        
    }
    
    func didRecieveDogsResult(status: Int, message: String, dogs: Array<Dog>) {
        print("Dogs received")
        print(dogs.count)
        self.dogs = dogs
        tableView.reloadData()
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
        print(self.dogs[indexPath.row])
        let item = self.dogs[indexPath.row] as! NSDictionary
        
//        let dog = Dog(name: "\(item["name"])", breed: "\(item["breed"])")
        var name = ""
        if let nameVal =  item["name"] {
            name = item["name"]! as! String
        }
        cell.textLabel?.text = name
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
