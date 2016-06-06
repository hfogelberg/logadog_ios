//
//  MedicationObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-06.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class MedicationObject {
    var medicationType = ""
    var product = ""
    var amount = ""
    var cost = ""
    var comment = ""
    var reminderDate = ""
    
    init(json:JSON) {
        self.medicationType = json["medicationType"].stringValue
        self.product = json["product"].stringValue
        self.amount = json["amount"].stringValue
        self.cost = json["cost"].stringValue
        self.comment = json["comment"].stringValue
        self.reminderDate = json["reminderDate"].stringValue
    }
}
