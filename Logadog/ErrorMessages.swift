//
//  ErrorMessages.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-17.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class ErrorMessages {
    static func messageForErrorCode(errorCode: Int) -> String {
        var message = ""
        switch errorCode{
            case STATUS_TOKEN_INVALID:
                message = "You have been signed logged out. Please sign in again."
            case STATUS_UNKNOWN_USER:
                message = "Wrong user name or password."
            case STATUS_WRONG_PASSWORD:
                message = "Wrong user name or password."
            case STATUS_HTTP_FORBIDDEN:
                message = "You have been signed logged out. Please sign in again."
            default:
                message = "An error has occured. Please restart the app and try again later."
        }
        
        return message
    }
}