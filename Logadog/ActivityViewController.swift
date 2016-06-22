//
//  ActivityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var isCompetitionSegue: UISegmentedControl!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var activityDatePicker: UIDatePicker!
    @IBOutlet weak var isCompetitionSwitch: UISegmentedControl!
    
    var dogId: String = ""
    var isCompetition = PRACTICE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't use IQKeyboardManager for this field
        dateTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        dateView.hidden = true
    }
    
    
    @IBAction func isCompetitionChanged(sender: AnyObject) {
        switch isCompetitionSwitch.selectedSegmentIndex
        {
        case 0:
            self.isCompetition = PRACTICE
        case 1:
            self.isCompetition = COMPETITION
        default:
            break;
        }
    }
    
    @IBAction func datePickerDoneTapped(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(activityDatePicker.date)
        dateTextField.text = date
        self.dateView.hidden = true
    }
    
    @IBAction func dateCancelTapped(sender: AnyObject) {
        dateView.hidden = true
    }
    
    @IBAction func dateFieldTapped(sender: AnyObject) {
       dateView.hidden = false
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        print("Save tapped")
        
        var activityType = ""
        var city = ""
        var club = ""
        var result = ""
        var comment = ""
        var activityDate = ""
        
        if let typeVal = typeTextfield.text as String? {
            activityType = typeVal
        }
        
        if let cityVal = cityTextField.text as String? {
            city = cityVal
        }
        
        if let clubVal = clubTextField.text as String? {
            club = clubVal
        }
        
        if let resultVal = resultTextField.text as String? {
            result = resultVal
        }
        
        if let commentVal = commentTextView.text as String? {
            comment = commentVal
        }
        
        if let dateVal = dateTextField.text as String? {
            activityDate = dateVal
        }
        
        let activity = [
            "activityType": activityType,
            "city": city,
            "club": club,
            "result": result,
            isCompetition: isCompetition,
            "comment": comment,
            "dogid": self.dogId,
            "token": TokenController.getToken()
        ]
        
        self.createActivity(activity)
        
    }
    
    func createActivity(activity: [String:String]) {
        RestApiManager.sharedInstance.postRequest(ROUTE_ACTIVITY, params: activity, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                // ToDo: Dsiplay error message
                print("ERROR: \(status)")
            }
        })
    }
}
