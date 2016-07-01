//
//  breedObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-07-01.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class BreedObject {
    var name = ""
    
    init(json: JSON) {
        name = json["name"].stringValue
    }
}