//
//  ProdtypeObject
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-07-01.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProdtypeObject {
    var name = ""
    var animal = ""
    var language = ""
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.language = json["lang"].stringValue
        self.animal = json["animal"].stringValue
    }
}
