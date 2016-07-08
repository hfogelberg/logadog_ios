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
    var medicationId = ""
    var petId = ""
    var productType = ""
    var make = ""
    var amount = ""
    var cost = ""
    var comment = ""
    var reminderDate = ""
    var medicationDate = ""
    
    init(json:JSON) {
        self.medicationId = json["_id"].stringValue
        self.petId = json["petId"].stringValue
        self.productType = json["productType"].stringValue
        self.make = json["make"].stringValue
        self.amount = json["amount"].stringValue
        self.cost = json["cost"].stringValue
        self.comment = json["comment"].stringValue
        self.reminderDate = json["reminder"].stringValue
        self.medicationDate = json["medicationDate"].stringValue
    }
}
