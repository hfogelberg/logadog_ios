//
//  jsonHandler.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-29.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class jsonHandler {
    static func fetchJsonString(url: String, urlParams: String, httpVerb: String, mustHaveToken: Bool) -> String {
        var responseString: String = ""
        
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
                // If required token is missing show message and redirect to login page
            }
        }
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            } else {
                if let response = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    responseString = response as String
                }
                print("responseString = \(responseString)")
            }
        }
        
        task.resume()
        
        return responseString
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

