//
//  DogsTableViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-28.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class DogsTableViewController: UITableViewController {

    var dogs: [Dog] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyDogs()
    }
    
    func getMyDogs() {
        var status = 0
        var message = ""
        var token = ""
        var userId = ""
        
        if let tokenVal: String = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN) {
            token = tokenVal
        }
        
        if let userIdVal: String = KeychainWrapper.stringForKey(KEYCHAIN_USER) {
            userId = userIdVal
        }
        
        let urlWithParams =  "\(API_ROUTE_URL)\(Routes.DOGS)/\(userId)?token=\(token)"
        print("Get Dogs url:  \(urlWithParams)")
        let myUrl = NSURL(string: urlWithParams)
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "\(Verbs.GET)"
        
        if token != "" {
//            request.addValue("Token token=\(token)", forHTTPHeaderField: "x-access-token")
            
            // Excute HTTP Request
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in

                if error != nil
                {
                    status = FALSE
                    
                    
                } else {
                    do {
                        if let response = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                            print(response)
                            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            if let statusResponse = jsonDictionary["success"] as? Int {
                                status = statusResponse
                            }
                            if let messageResponse = jsonDictionary["message"] as? String {
                                message = messageResponse
                            }
                            if let dogResponse = jsonDictionary["dogs"] as! NSArray? {
                                for dog in dogResponse {
                                    var name = ""
                                    var breed = ""
                                    
                                    if let dogName = dog["name"] as? String {
                                        name = dogName
                                    }
                                    
                                    if let dogBreed = dog["breed"] as? String {
                                        breed = dogBreed
                                    }
                                    
                                    let newDog = Dog(name: name, breed: breed)
                                    self.dogs.append(newDog)
                                }
                                self.tableView.reloadData()
                            }
                            
                            if status == FALSE {
                                let messageTitle = MSG_SIGN_IN
                                let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.performSegueWithIdentifier("returnToLoginSegue", sender: self)
                                    }
                                }))
                                self.presentViewController(alert, animated: true, completion: nil);
                            } else {
                                
                            }
                        }
                    } catch {
                        status = FALSE
                        // ToDo: Fix error message and use constant
                        message = "Error reading from server"
                        print(message)
                    }
                }
            }
            
        
            task.resume()
        } else {
            // ToDo
            // No token. Show error message
        }
    }
    func checkTokenAndGetUSer() -> String {
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("logadogLoginKey")
        
        if hasLogin {
            if let storedUserId = NSUserDefaults.standardUserDefaults().valueForKey("userid") as? String {
                print(storedUserId)
                return storedUserId
            } else {
                return ""
            }
        } else {
            return ""
        }
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
        
        let dog = self.dogs[indexPath.row]
        cell.textLabel!.text = dog.name
        
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
