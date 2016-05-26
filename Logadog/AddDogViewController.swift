//
//  AddDogViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddDogViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var breedTextfield: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    
    var gender = MALE

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func genderSwitchChanged(sender: AnyObject) {
        switch genderSwitch.selectedSegmentIndex
        {
        case 0:
            self.gender = MALE
        case 1:
            self.gender = FEMALE
        default:
            break;
        }
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var name = ""
        var breed = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        
        if let breedVal = breedTextfield.text as String? {
            breed = breedVal
        }
        
        let body = [
            "name": name,
            "breed": breed,
            "gender": gender,
            "token": TokenController.getToken(),
            "userid": TokenController.getUserId()
        ]
        
        RestApiManager.sharedInstance.postHttp(body, route: ROUTE_DOGS, onCompletion:  { (json: JSON) -> () in
            var status = STATUS_OK
            
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status == STATUS_OK {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // ToDo: Dsiplay error message
                print("ERROR: \(status)")
            }
        })
    }
}
