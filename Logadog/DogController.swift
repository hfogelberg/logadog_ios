//
//  DogController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-11.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

protocol DogControllerProtocol {
    //func didRecieveDogsResult(status: Int, message: String, dogs: NSArray)
    func didRecieveDogsResult(status: Int, message: String, dogs: Array<Dog>)
}

class DogController {
    var delegate: DogControllerProtocol
    
    init(delegate: DogControllerProtocol?) {
        self.delegate = delegate!
    }
    
    func getDogsArray(params: String, route: String) {
        
        //var tides: [Tide] = []
        var dogs: [Dog] = []
        var isOk = 0
        var message = ""
        
        let parameterString = params.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let requestURL = NSURL(string:"\(API_ROUTE_URL)\(route)?\(parameterString)")!
        print(requestURL)
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            var err: NSError?
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
                if let jsonDictionary:NSDictionary = jsonDictionary {
                    if let messageResponse = jsonDictionary["message"] as? String {
                        message = messageResponse
                    }
                    if let successResponse = jsonDictionary["success"] as? Int {
                        isOk = successResponse
                    }
                    if let responseArr = jsonDictionary["response_data"]  as! NSArray? {
                        dogs = responseArr as! Array<Dog>
                    }
                    
                    self.delegate.didRecieveDogsResult(isOk, message: message, dogs: dogs)
                }
            } catch {
                print(err)
            }
        }
        
        task.resume(
        )
    }
}
