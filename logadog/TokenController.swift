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
    
    static func getToken() -> String {
        var token: String = ""
        if let tokenVal = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN) as String? {
            token = tokenVal
        }
        
        return token
    }
    
    static func getUserId() -> String {
        var userid = ""
        
        if let idVal = KeychainWrapper.stringForKey(KEYCHAIN_USER_ID) as String? {
            userid = idVal
        }
        
        return userid
    }
    
    static func saveTokenAndUser(token : String, userId: String) -> Bool {
        var saveOk = true
        
        saveOk = KeychainWrapper.setString(token, forKey: KEYCHAIN_TOKEN)
        
        if saveOk {
            saveOk = KeychainWrapper.setString(userId, forKey: KEYCHAIN_USER_ID)
        }
        
        return saveOk
    }
    
    static func removeTokenAndUser() {
        KeychainWrapper.removeObjectForKey(KEYCHAIN_TOKEN)
        KeychainWrapper.removeObjectForKey(KEYCHAIN_USER_ID)
    }
}