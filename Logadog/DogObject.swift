//
//  DogObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class DogObject {
    var id: String
    var name: String!
    var breed: String!
    var gender: String!
    
    init(json: JSON) {
        id = json["_id"].stringValue
        name = json["name"].stringValue
        breed = json["breed"].stringValue
        gender = json["gender"].stringValue
    }
}
