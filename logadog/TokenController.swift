//
//  TokenHelper.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-09.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol TokenDelegate {
    func didRecieveTokenResults(status: Int, token: NSDictionary)
    func tokenIsValidResult(staus: Int)
}

class TokenController {
    var delegate: TokenDelegate
    
    init(delegate: TokenDelegate) {
        self.delegate = delegate
    }

    
    static func hasToken() -> Bool {
        let token: String? = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN)
        
        if (token != nil) {
            return true
        } else {
            return false
        }
    }
    
    static func getToken() -> String? {
        let token = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN) as String?
        
        if token == "null" {
            return nil
        } else {
            return token
        }
    }
    
    static func getUserId() -> String? {
        return KeychainWrapper.stringForKey(KEYCHAIN_USER_ID) as String?
    }
    
    static func saveTokenAndUser(token : String, userId: String, userName: String) -> Bool {
        var saveOk = true
        
        saveOk = KeychainWrapper.setString(token, forKey: KEYCHAIN_TOKEN)
        
        if saveOk {
            saveOk = KeychainWrapper.setString(userId, forKey: KEYCHAIN_USER_ID)
        }
        
        if saveOk {
            saveOk = KeychainWrapper.setString(userName, forKey: KEYCHAIN_USER_NAME)
        }
        
        return saveOk
    }
    
    static func removeTokenAndUser() {
        KeychainWrapper.removeObjectForKey(KEYCHAIN_TOKEN)
        KeychainWrapper.removeObjectForKey(KEYCHAIN_USER_ID)
        KeychainWrapper.removeObjectForKey(KEYCHAIN_USER_NAME)
    }
    
//    func validateToken() {
//        var err: NSError?
//        var user: Dictionary<String, String>?
//        var statusCode = STATUS_OK
//        
//        let token = TokenController.getToken()
//        let params = "token=\(token)"
//        let parameterString = params.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//        let requestURL = NSURL(string:"\(API_ROUTE_URL)\(ROUTE_CHECK_TOKEN)?\(parameterString)")!
//        print(requestURL)
//        let request = NSMutableURLRequest(URL: requestURL)
//        request.HTTPMethod = "GET"
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
//            do {
//                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
//                print(jsonDictionary)
//                
//                if let jsonDictionary:NSDictionary = jsonDictionary {
//                    if let successResponse = jsonDictionary["success"] as? Int {
//                        statusCode = successResponse
//                    }
//                    if let responseDict: Dictionary<String, String> = jsonDictionary["user"] as? Dictionary<String, String> {
//                        print(responseDict)
//                        user = responseDict
//                    }
//                    
//                    self.delegate.tokenIsValidResult(statusCode)
//                }
//            } catch {
//                print(err)
//                if let errVal = err as NSError? {
//                    statusCode = errVal.code
//                }
//                self.delegate.tokenIsValidResult(statusCode)
//            }
//        }
//        
//        task.resume(
//        )
//    }
}