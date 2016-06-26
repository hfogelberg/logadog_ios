//
//  ContactObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContactObject {
    var id = ""
    var name = ""
    var company = ""
    var web = ""
    var email = ""
    var phone = ""
    var street = ""
    var postalcode = ""
    var city = ""
    var country = ""
    var comment = ""
    
    init(json: JSON) {
        id = json["_id"].stringValue
        name = json["name"].stringValue
        company = json[""].stringValue
        web = json["company"].stringValue
        email = json["email"].stringValue
        phone = json["phone"].stringValue
        street = json["street"].stringValue
        postalcode = json["postalcode"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        comment = json["comment"].stringValue
    }
    
}
