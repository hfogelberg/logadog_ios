//
//  DogViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManager

class DogViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var breedTextfield: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var dobTextfield: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    var gender = MALE
    var dog: DogObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        // Don't use IQKeyboardManager for this field
        dobTextfield.inputAccessoryView = UIView()
//        self.dobTextfield.inputAccessoryView = dateView
//         dobTextfield.addDoneOnKeyboardWithTarget(self, action: Selector(self.dateDoneAction()))
        
        if dog != nil {
            showDog()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dateView.hidden = true
    }
    
    func showDog(){
        nameTextfield.text = dog.name
        breedTextfield.text = dog.breed

        if gender == MALE {
            self.genderSwitch.selectedSegmentIndex = 0
        } else {
            self.genderSwitch.selectedSegmentIndex = 1
        }
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
    
    @IBAction func dobTextfieldTappd(sender: AnyObject) {
        print("DOB field tapped")
        self.dateView.hidden = false
    }
    
    @IBAction func dobDoneButtonTapped(sender: AnyObject) {
        print("Done tapped")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobDate = dateFormatter.stringFromDate(dobPicker.date)
        dobTextfield.text = dobDate
        self.dateView.hidden = true
    }
    
    @IBAction func dobCancelTapped(sender: AnyObject) {
        print("Cancel tapped")
        self.dateView.hidden = true
    }
    
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var name = ""
        var breed = ""
        var route = ""
        var body: [String:String]
        var dob = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        
        if let breedVal = breedTextfield.text as String? {
            breed = breedVal
        }
        
        if let dobVal = dobTextfield.text as String? {
            dob = dobVal
        }
        
        print("Date of birth: \(dob)")
        
        if dog == nil {
            body = [
                "name": name,
                "breed": breed,
                "gender": gender,
                "dob": dob,
                "token": TokenController.getToken(),
                "userid": TokenController.getUserId()
            ]
            
            route = ROUTE_DOGS
        } else {
            body = [
                "name": name,
                "breed": breed,
                "gender": gender,
                "dob": dob,
                "token": TokenController.getToken(),
                "dogid": self.dog.id
            ]
            
            route = ROUTE_CHANGE_DOG
        }
        
        postJson(route, body: body)
    }
    
    func postJson(route: String, body:[String:String]) {
        RestApiManager.sharedInstance.postRequest(route, params: body, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            } else {
                // ToDo: Dsiplay error message
                print("ERROR: \(status)")
            }
        })
    }
}
