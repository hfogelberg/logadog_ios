//
//  APIController
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-10.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation


protocol APIControllerProtocol {
    func didRecieveAPIResults(status: Int, message: String, results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate!
    }
    
    
     func postJson(params: String, route:String, verb: String) {
        var jsonResponse: JsonResponse = JsonResponse()
        var responseData: NSDictionary?
        var isOk = 0
        var message = ""
        
        
        let url = NSURL(string: "\(API_ROUTE_URL)\(route)")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "\(verb)"
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            var err: NSError?
            do {
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                print(jsonDictionary)
                
                if let jsonDictionary:NSDictionary = jsonDictionary {
                    if let messageResponse = jsonDictionary["message"] as? String {
                        message = messageResponse
                    }
                    if let successResponse = jsonDictionary["success"] as? Int {
                        isOk = successResponse
                    }
                    if let responseDict:NSDictionary = jsonDictionary["response_data"] as! NSDictionary {
                        print(responseDict)
                        responseData = responseDict
                    }
                    
                    self.delegate.didRecieveAPIResults(isOk, message: message, results: responseData!)
                    
                }
            } catch {
                print(err)
            }
        }
        
        task.resume(
        )
    }
}