//
//  ActivityTypes.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-07-03.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityTypeObject {
    var name = ""
    
    init(json: JSON) {
        self.name = json["name"].stringValue
    }
}