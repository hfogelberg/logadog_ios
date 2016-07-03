//
//  AppearanceObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApperanceObject {
    var petId: String!
    var color: String!
    var heightInCm: String!
    var weightInKg: String!
    var comment: String!
    
    init() { }

    init(json: JSON) {
        setData(json)
    }
    
    func setData(json:JSON) {
        self.petId = json["petId"].stringValue
        self.color = json["color"].stringValue
        self.heightInCm = json["heightInCm"].stringValue
        self.weightInKg = json["weightInKg"].stringValue
        self.comment = json["comment"].stringValue
    }
}
