//
//  PurchaceObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class PurchaceObject {
    var id = ""
    var comment = ""
    var date = ""
    var cost = ""
    var object = ""
    
    init(json:JSON) {
        id = json["_id"].stringValue
        comment = json["comment"].stringValue
        date = json["date"].stringValue
        cost = json["cost"].stringValue
        object = json["object"].stringValue
    }
}
