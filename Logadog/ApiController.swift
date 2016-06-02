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
    
    func getRequest(route: String, params: String, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(route)?\(params)"
        print("GET route \(route)")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func postRequest(route: String, params: [String:String], onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(route)"
        print("POST to route \(route)")
        makeHTTPPostRequest(route, params: params, onCompletion:  {json, err in
            onCompletion(json as JSON)
        })
    }
    
    
    private func makeHTTPGetRequest(urlWithParams: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlWithParams)!)
        print(request)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    private func makeHTTPPostRequest(path: String, params: [String: String], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])

            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
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
}
