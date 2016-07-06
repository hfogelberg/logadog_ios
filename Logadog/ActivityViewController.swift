//
//  ActivityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activitytypeTableview: UITableView!
    
    var activity: ActivityObject!
    var pet: PetObject!
    var isCompetition = PRACTICE
    var auto: [String] = []
    var activityTypes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activitytypeTableview.delegate = self
        self.activitytypeTableview.dataSource = self
        self.typeTextfield.delegate = self
        
        // Don't use IQKeyboardManager for this field
        dateTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        dateView.hidden = true
        
        if activity != nil {
            self.showActivity()
            self.saveButton.enabled = false
            self.editButton.enabled = true
        } else {
            self.saveButton.enabled = true
            self.editButton.enabled = false
        }
        
        self.activitytypeTableview.hidden = true
        self.getActivityTypes()
    }
    
    
    func getActivityTypes() {
        self.activityTypes.removeAll()
        var route = ""
        
        if pet.animaltype != "" {
            route = "\(ROUTE_ACTIVITY_TYPES)?lang=\(DEFAULT_LANGUAGE)&animal=\(pet.animaltype)"
        } else {
            route = "\(ROUTE_ACTIVITY_TYPES)?lang=\(DEFAULT_LANGUAGE)"
        }
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            print(json)
            if let types = json["data"].array {
                for type in types {
                    self.activityTypes.append(ActivityTypeObject(json: type).name)
                }
            }
        })
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
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.editButton.enabled = false
        self.saveButton.enabled = true
        
        self.enableFields()
    }
    
    func enableFields() {
        self.typeTextfield.enabled = true
        self.clubTextField.enabled = true
        self.cityTextField.enabled = true
        self.resultTextField.enabled = true
        self.positionTextField.enabled = true
        self.timeTextField.enabled = true
        self.dateTextField.enabled = true
        self.commentTextView.editable = true
        self.isCompetitionSwitch.enabled = true
        self.dateTextField.enabled = true
        
        self.typeTextfield.borderStyle = .RoundedRect
        self.clubTextField.borderStyle = .RoundedRect
        self.cityTextField.borderStyle = .RoundedRect
        self.resultTextField.borderStyle = .RoundedRect
        self.positionTextField.borderStyle = .RoundedRect
        self.timeTextField.borderStyle = .RoundedRect
        self.dateTextField.borderStyle = .RoundedRect
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
        print("Date field tapped")
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
            "isCompetition": isCompetition,
            "comment": comment,
            "activityDate": activityDate
        ]
        
        if self.activity == nil {
            self.createActivity(activity)
        } else {
            self.updateActivity(activity)
        }
    }
    
    func updateActivity(activity:[String:String]) {
        let activityId = self.activity.activityId
        let route = "\(ROUTE_PETS)/\(ROUTE_ACTIVITY)/\(activityId)"
        
        RestApiManager.sharedInstance.postRequest(route, params: activity, onCompletion: {(json:JSON) -> () in
            var status = STATUS_OK
            
            if let statusVal = json["status"].numberValue as Int? {
                status = statusVal
            }
            
            
            if status == STATUS_OK {
                // ToDo!!!
                
            } else {
                var message = ""
                if let messageVal = json["message"].stringValue as String? {
                    message = messageVal
                }
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Cacel", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
            // ToDo: Handle error and fix navigation
        })
    }
    
    func createActivity(activity: [String:String]) {
        let route = "\(ROUTE_PETS)/\(self.pet.id)/\(ROUTE_ACTIVITY)?lang=\(DEFAULT_LANGUAGE)"
        RestApiManager.sharedInstance.postRequest(route, params: activity, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            print(json)
            
            if let statusVal = json["status"].numberValue as Int? {
                status = statusVal
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                var message = ""
                if let messageVal = json["message"].stringValue as String? {
                    message = messageVal
                }
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Cacel", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func activitytypeChanged(sender: AnyObject) {
        self.activitytypeTableview.hidden = false
        
        if let text = typeTextfield.text as String? {
            auto.removeAll(keepCapacity: false)
            for curString in self.activityTypes
            {
                let myString:NSString! = curString as NSString
                
                let substringRange :NSRange! = myString.rangeOfString(text)
                if (substringRange.location  == 0)
                {
                    auto.append(curString)
                }
            }
        }
        
        if auto.count > 0 {
            self.activitytypeTableview.reloadData()
        } else {
            self.activitytypeTableview.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.typeTextfield.text = auto[indexPath.row]
        self.activitytypeTableview.hidden = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auto.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        cell.textLabel!.text = self.auto[indexPath.row]
        return cell
    }
    
}
