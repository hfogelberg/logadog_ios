//
//  KeychainHelper.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-02.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class KeychainHelper {
    static func saveToKeychain(token: String, userId: String) {
        let keychainWrapper = KeychainWrapper()
        keychainWrapper.setValue(token, forKey: KEYCHAIN_TOKEN)
        keychainWrapper.setValue(userId, forKey: KEYCHAIN_USER)
        keychainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func hasToken() -> Bool {
        var hasToken = true
        
        return hasToken
    }
    
    static func getToken() -> String {
        var token = ""
        
        return token
    }
    
    static func getUserId() -> String {
        var userId = ""
        
        return userId
    }
    
    static func getTokenAndUserId() -> (String, String) {
        var userId = ""
        var token = ""
        
        return (token, userId)
        
    }
    
    static func resetTokens() {
        let keyChainWrapper = KeychainWrapper()
        keyChainWrapper.delete(KEYCHAIN_TOKEN)
        keyChainWrapper.delete(KEYCHAIN_USER)
        keyChainWrapper.writeToKeychain()
        NSUserDefaults.standardUserDefaults().synchronize()
        
        print("Checking Keychain: \(keyChainWrapper.valueForKey(KEYCHAIN_USER))")
    }
}