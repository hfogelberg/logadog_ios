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
    var position = ""
    var time = ""
    var isCompetition = ""
    var comment = ""
    var activityDate = ""
    
    init(json:JSON) {
        print(json)
        activityId = json["_id"].stringValue
        activityType = json["activityType"].stringValue
        city = json["city"].stringValue
        club = json["club"].stringValue
        result = json["result"].stringValue
        position = json["position"].stringValue
        time = json["time"].stringValue
        isCompetition = json["isCompetition"].stringValue
        comment = json["comment"].stringValue
        activityDate = json["activityDate"].stringValue
    }
}
