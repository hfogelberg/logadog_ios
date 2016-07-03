//
//  AnimaltypeObject.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-07-03.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnimaltypeObject{
    var name = ""
    var language = ""
    var animal = ""
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.language = json["lang"].stringValue
        self.animal = json["animal"].stringValue
    }
}
