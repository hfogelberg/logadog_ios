//
//  DogsTableViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-28.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class DogsTableViewController: UITableViewController {
    
    var dogs = [Dog].self

    override func viewDidLoad() {
        super.viewDidLoad()

        print("DogsTableViewController")
        
        getMyDogs()
    }
    
    func getMyDogs() {        var running = false
        let dogs = jsonHandler.fetchJsonString("dogs", urlParams: "", httpVerb: "GET", mustHaveToken: true)
        running = true
        
        print(dogs)

    }
    
//    func getMyDogs() {
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//
//        
//        let userPasswordString = "dogs\(checkTokenAndGetUSer())"
//        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
//        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
//         let authString = "Basic \(base64EncodedCredential)"
//         config.HTTPAdditionalHeaders = ["Authorization" : authString]
//         let session = NSURLSession(configuration: config)
//        
//         var running = false
//         let url = NSURL(string: "\(API_ROUTE_URL)login")
//         let task = session.dataTaskWithURL(url!) {
//             (let data, let response, let error) in
//             if let _ = response as? NSHTTPURLResponse {
//                 let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                 print(dataString)
//             }
//             running = false
//         }
//        
//         running = true
//         task.resume()
//         
//         while running {
//             print("waiting...")
//             sleep(1)
//         }
//    }
    
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
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
