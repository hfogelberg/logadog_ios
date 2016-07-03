//
//  PetObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class PetObject {
    var id: String
    var name: String!
    var animaltype: String!
    var breed: String!
    var gender: String!
    var dob: String!
    
    init(json: JSON) {
        id = json["_id"].stringValue
        name = json["name"].stringValue
        animaltype = json["animaltype"].stringValue
        breed = json["breed"].stringValue
        gender = json["gender"].stringValue
        dob = json["dob"].stringValue
    }
}
