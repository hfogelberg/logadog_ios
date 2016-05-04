//
//  TokenHelper.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-02.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class TokenHelper {
    static func getLoginToken() -> String {
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("logadogLoginKey")
        
        if hasLogin {
            if let token = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String {
                return token
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}