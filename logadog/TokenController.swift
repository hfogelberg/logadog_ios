//
//  TokenHelper.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-09.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class TokenController {
    static func hasToken() -> Bool {
        let token: String? = KeychainWrapper.stringForKey(KEYCHAIN_TOKEN)
        
        if (token != nil) {
            return true
        } else {
            return false
        }
        
    }
    
    static func getToken() -> String? {
        return KeychainWrapper.stringForKey(KEYCHAIN_TOKEN) as String?
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
}