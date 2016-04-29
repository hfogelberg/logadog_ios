//
//  ApplicationSettings.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

let API_ROUTE_URL = "http://localhost:3000/api/"

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


