//
//  jsonHandler.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-29.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class jsonHandler {
    static func fetchJsonString(url: String, urlParams: String, httpVerb: String, mustHaveToken: Bool) -> (status: Bool, message: String, jsonString: String) {
        var responseString: String = ""
        var status = false
        var message = ""
        var jsonString = ""
        
        var urlWithParams =  "\(API_ROUTE_URL)\(url)"
        if urlParams != "" {
            urlWithParams = "\(urlWithParams)&\(urlParams)"
        }
        let myUrl = NSURL(string: urlWithParams)
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = httpVerb
        
        let token: String = getLoginToken()
        print(token)
        if token != "" {
            request.addValue("Token token=\(token)", forHTTPHeaderField: "x-access-token")
            print("Token added")
        } else {
            if mustHaveToken == true {
                // If required token is missing return error message
                return (false, MSG_TOKEN_MISSING, "")
            }
        }
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            var status = false
            var message = ""
            var jsonString = ""
            
            if error != nil
            {
                status = false

            } else {
                
//                if let response = NSString(data: data!, encoding: NSUTF8StringEncoding) {
//                    responseString = response as String
//                }
//                print("responseString = \(responseString)")
                
                do {
                    if let response = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                        print(response)
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        if let statusResponse = jsonDictionary["success"] as? Bool {
                            status = statusResponse
                        }
                        if let messageResponse = jsonDictionary["message"] as? String {
                            message = messageResponse
                        }
                        
                        print(status)
                        print(message)
                        
                       print("")
                    }
                } catch {
                    print("bad things happened")
                    
                    status = false
                    // ToDo: Use constant
                    message = "Error"
                }
            }
        }
        
        task.resume()
        
        return (status, message, jsonString)
    }
    

    private func parseJsonBase(data: NSData) -> (status: Bool, errMsg: String, jsonString: String) {
        var status = false
        var errMsg = ""
        var jsonString = ""
        
        
        do {
            if let _ = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                print(jsonDictionary)
                print("")
//                if let rawData = jsonDictionary["extremes"] as! NSArray?{
                
//                    for data in rawData{
//                        let height = data["height"] as! Double
//                        let date = data["date"] as! String
//                        let type = data["type"] as! String
                    
//                        let tide = Tide(type: type, height: height, date: date)
//                        self.tides.append(tide)
                        
//                        // Reload tableView
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            self.tableView.reloadData()
//                        })
//                    }
//                }
                
            }
            
        } catch {
            print("bad things happened")
        }
        
        return (status, errMsg, jsonString)
    }
    
    private static func getLoginToken() -> String {
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("logadogLoginKey")
        
        if hasLogin {
            if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String {
                return token
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

