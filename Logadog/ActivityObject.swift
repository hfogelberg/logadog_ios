//
//  ActivityObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivityObject {
    var activityId = ""
    var activityType = ""
    var city = ""
    var club = ""
    var result = ""
    var isCompetition = FALSE
    var comment = ""
    var activityDate = ""
    
    init(json:JSON) {
        activityId = json["_id"].stringValue
        activityType = json["activityDate"].stringValue
        city = json["city"].stringValue
        club = json["club"].stringValue
        result = json["result"].stringValue
        isCompetition = json["isCompetition"].intValue
        comment = json["comment"].stringValue
        activityDate = json["activityDate"].stringValue
    }
}
