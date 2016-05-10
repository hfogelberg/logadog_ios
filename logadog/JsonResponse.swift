//
//  JsonResponse.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-10.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class JsonResponse {
    var isOk: Int?
    var message: String?
    
    init() {
        self.isOk = 1
        self.message = ""
    }
}