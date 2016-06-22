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
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var activityDatePicker: UIDatePicker!
    @IBOutlet weak var isCompetitionSwitch: UISegmentedControl!
    
    var activity: ActivityObject!
    var dogId: String = ""
    var isCompetition = PRACTICE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't use IQKeyboardManager for this field
        dateTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        dateView.hidden = true
        
        if activity != nil {
            self.showActivity()
        }
    }
    
    
    func showActivity() {
        self.typeTextfield.text = activity.activityType
        self .clubTextField.text = activity.club
        self.cityTextField.text = activity.city
        self.resultTextField.text = activity.result
        self.positionTextField.text = activity.position
        self.timeTextField.text = activity.time
        self.commentTextView.text = activity.comment
        self.dateTextField.text = activity.activityDate

        if self.isCompetition == COMPETITION {
            self.isCompetitionSwitch.selectedSegmentIndex = 0
        } else {
            self.isCompetitionSwitch.selectedSegmentIndex = 1
        }
        
        self.typeTextfield.enabled = false
        self.clubTextField.enabled = false
        self.cityTextField.enabled = false
        self.resultTextField.enabled = false
        self.positionTextField.enabled = false
        self.timeTextField.enabled = false
        self.dateTextField.enabled = false
        self.commentTextView.editable = false
        self.isCompetitionSwitch.enabled = false
        self.dateTextField.enabled = false
        
        self.typeTextfield.borderStyle = .None
        self.clubTextField.borderStyle = .None
        self.cityTextField.borderStyle = .None
        self.resultTextField.borderStyle = .None
        self.positionTextField.borderStyle = .None
        self.timeTextField.borderStyle = .None
        self.dateTextField.borderStyle = .None
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
        var position = ""
        var time = ""
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
        
        if let positionVal = positionTextField.text as String? {
            position = positionVal
        }
        
        if let timeVal = timeTextField.text as String? {
            time = timeVal
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
            "position": position,
            "time": time,
            isCompetition: isCompetition,
            "comment": comment,
            "activityDate": activityDate,
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
