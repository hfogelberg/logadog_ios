////
////  JsonHelper.swift
////  Logadog
////
////  Created by Henrik Fogelberg on 2016-05-09.
////  Copyright © 2016 Henrik Fogelberg. All rights reserved.
////
//
//import Foundation
//
//class ApiHelper {
//    static func postJson(params: String, route:String, verb: String) -> (JsonResponse, NSDictionary?) {
//        var jsonResponse: JsonResponse = JsonResponse()
//        var responseData: NSDictionary?
//        
//        let url = NSURL(string: "\(API_ROUTE_URL)\(route)")
//        let request = NSMutableURLRequest(URL:url!)
//        request.HTTPMethod = "\(verb)"
//        
//        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                print("error=\(error)")
//                return
//            }
//            
//            print("response = \(response)")
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("responseString = \(responseString)")
//            
//            var err: NSError?
//            do {
//                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
//                print(jsonDictionary)
//                
//                if let jsonDictionary:NSDictionary = jsonDictionary {
//                    if let messageResponse = jsonDictionary["message"] as? String {
//                        jsonResponse.message = messageResponse
//                    }
//                    if let successResponse = jsonDictionary["success"] as? Int {
//                        jsonResponse.isOk    = successResponse
//                    }
//                    if let responseDict:NSDictionary = jsonDictionary["response_data"] as! NSDictionary {
//                        print(responseDict)
//                        responseData = responseDict
//                    }
//                    
////                    if let responseDict = jsonDictionary["response_data"] as? NSDictionary{
//////                        responseData = responseString as! String
//////                        let responseData = responseString as! String
////                        let responseData = NSString(data: responseDict, encoding: NSASCIIStringEncoding) as! String
////                        print(responseData)
////                        
////                    }
//                    
//                    
//                    
//                }
//            } catch {
//                print(err)
//            }
//        }
//        
//        task.resume(
//            return (jsonResponse, responseData)
//        )
//    }
//}