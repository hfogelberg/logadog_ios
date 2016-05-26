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
    
    func getDogs(params: String, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(ROUTE_DOGS)?\(params)"
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func validateToken(params: String, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(ROUTE_CHECK_TOKEN)?\(params)"
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }

    func authenticate(params: String, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/authenticate?\(params)"
        
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func signup(params: [String:String], onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/users"
        
        makeHTTPPostRequest(route, params: params, onCompletion:  {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func updateDog(body: [String:String], onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(INFO_DESCRIPTION)"
        makeHTTPPostRequest(route, params: body, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func postHttp(params: [String:String], route: String, onCompletion: (JSON) -> Void) {
        let route = "\(API_ROUTE_URL)/\(route)"
        
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
