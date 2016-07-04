//
//  ApiController.swift
//  jsontest
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    func getRequest(route: String, params: String = "",  authenticated: Bool = true, onCompletion: (JSON) -> Void) {
        var route = "\(API_ROUTE_URL)/\(route)"
        if params != "" {
            route = "\(API_ROUTE_URL)/\(route)?\(params)"
        }
        
        print("GET route \(route)")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func postRequest(route: String, params: [String:String], authenticated: Bool = true, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(route)"
        print("POST to route \(route)")
        print(params);
        makeHTTPPostRequest(route, params: params, authenticated: authenticated, onCompletion:  {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func deleteRequest(route: String, params: String = "",  authenticated: Bool = true, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(route)"
        
        print("DELETE route \(route)")
        makeHTTPDeleteRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    private func makeHTTPGetRequest(urlWithParams: String,authenticated: Bool = true, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlWithParams)!)
        print(request)
        
        //let session = NSURLSession.sharedSession()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        if authenticated {
            let auth = getAuthentication() as [NSObject : AnyObject]
            config.HTTPAdditionalHeaders = auth
        }
        
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                print(json)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    private func makeHTTPDeleteRequest(urlWithParams: String,authenticated: Bool = true, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlWithParams)!)
        request.HTTPMethod = "Delete"
        print(request)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        if authenticated {
            let auth = getAuthentication() as [NSObject : AnyObject]
            config.HTTPAdditionalHeaders = auth
        }
        
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                print(json)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    private func makeHTTPPostRequest(path: String, params: [String: String], authenticated: Bool, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])

            request.HTTPBody = jsonBody
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            if authenticated {
                config.HTTPAdditionalHeaders = getAuthentication() as [NSObject : AnyObject]
            }
            
            let session = NSURLSession(configuration: config)
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    print(json)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
    
    private func getAuthentication() -> NSDictionary {
        let userId = TokenController.getUserId()
        let token = TokenController.getToken()
        let authString = [
            "X-Auth-Token": token,
            "X-User-Id": userId
        ]
        
        return authString
    }
}
