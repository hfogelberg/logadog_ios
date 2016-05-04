//
//  Api.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-02.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

enum Routes: String {
    case AUTHENTICATE = "authenticate"
    case USERS = "users"
    case DOGS = "dogs"
}


enum Verbs: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}