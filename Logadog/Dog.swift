//
//  Dog.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-04-29.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import Foundation

class Dog {
    var name: String = ""
    var breed: String = ""
    var gender: String = ""
    
    init(name: String?, breed: String?, gender: String?) {
        if let nameVal = name {
            self.name = nameVal
        }
        if let breedVal = breed {
            self.breed = breedVal
        }
        if let genderVal = gender {
            self.gender = genderVal
        }
    }
}