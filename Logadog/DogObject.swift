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
    var name: String!
    var breed: String!
    var gender: String!
    
    init(json: JSON) {
        name = json["name"].stringValue
        breed = json["breed"].stringValue
        gender = json["gender"].stringValue
    }
}
