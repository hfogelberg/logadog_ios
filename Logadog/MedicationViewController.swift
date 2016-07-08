//
//  MedicationViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-06.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class MedicationViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var prodtypeTextfield: UITextField!
    @IBOutlet weak var makeTextfield: UITextField!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var medDateTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var reminderTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var prodtypesTableview: UITableView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateDoneButton: UIBarButtonItem!
    @IBOutlet weak var dateCancelButton: UIBarButtonItem!
    
    var petId = ""
    var medication: MedicationObject!
    var auto: [String] = []
    var prodtypes = [String]()
    var dateFieldType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        self.prodtypesTableview.delegate = self
        self.prodtypesTableview.dataSource = self
        
        self.medDateTextfield.delegate = self
        self.reminderTextfield.delegate = self
        
        self.prodtypeTextfield.delegate = self
        
        // Don't use IQKeyboardManager for this field
        self.medDateTextfield.inputAccessoryView = UIView()
        self.medDateTextfield.inputAccessoryView = UIView()
        
        self.dateView.hidden = true
   
        if medication != nil {
            self.showMedication()
        } else {
            self.enableFields()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prodtypesTableview.hidden = true
        getMedTypes()
    }
    
    func getMedTypes() {
        self.prodtypes.removeAll()
        let route = "\(ROUTE_PROD_TYPES)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            print(json)
            if let prodtypes = json["data"].array {
                for prod in prodtypes {
                    self.prodtypes.append(ProdtypeObject(json: prod).name)
                }
            }
        })
    }
    
    func showMedication() {
        self.prodtypeTextfield.text = self.medication.productType
        self.makeTextfield.text = self.medication.make
        self.medDateTextfield.text = self.medication.medicationDate
        self.amountTextfield.text = self.medication.amount
        self.costTextfield.text = self.medication.cost
        self.reminderTextfield.text = self.medication.reminderDate
        self.commentTextview.text = self.medication.comment
        
        self.disableFields()
    }
    
    func disableFields() {
        dispatch_async(dispatch_get_main_queue()) {
            self.prodtypeTextfield.borderStyle = .None
            self.makeTextfield.borderStyle = .None
            self.medDateTextfield.borderStyle = .None
            self.amountTextfield.borderStyle = .None
            self.costTextfield.borderStyle = .None
            self.reminderTextfield.borderStyle = .None
            
            self.prodtypeTextfield.enabled = false
            self.makeTextfield.enabled = false
            self.medDateTextfield.enabled = false
            self.amountTextfield.enabled = false
            self.costTextfield.enabled = false
            self.reminderTextfield.enabled = false
            
            self.editButton.enabled = true
            self.saveButton.enabled = false     
        }
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        enableFields()
    }
    
    func enableFields() {
        dispatch_async(dispatch_get_main_queue()) {
            self.prodtypeTextfield.enabled = true
            self.makeTextfield.enabled = true
            self.medDateTextfield.enabled = true
            self.amountTextfield.enabled = true
            self.costTextfield.enabled = true
            self.reminderTextfield.enabled = true
        
            self.prodtypeTextfield.borderStyle = .RoundedRect
            self.makeTextfield.borderStyle = .RoundedRect
            self.medDateTextfield.borderStyle = .RoundedRect
            self.amountTextfield.borderStyle = .RoundedRect
            self.costTextfield.borderStyle = .RoundedRect
            self.reminderTextfield.borderStyle = .RoundedRect
        
            self.editButton.enabled = false
            self.saveButton.enabled = true
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var productType = ""
        var make = ""
        var amount = ""
        var medDate = ""
        var cost = ""
        var reminder = ""
        var comment = ""
        
        if let productVal = self.prodtypeTextfield.text as String? {
            productType = productVal
        }
        
        if let makeVal = self.makeTextfield.text as String? {
            make = makeVal
        }
        
        if let amountVal = self.amountTextfield.text as String? {
            amount = amountVal
        }
        
        if let medDateVal = self.medDateTextfield.text as String? {
            medDate = medDateVal
        }
        
        if let costVal = self.costTextfield.text as String? {
            cost = costVal
        }
        
        if let reminderVal = self.reminderTextfield.text as String? {
            reminder = reminderVal
        }
        
        if let commentVal = self.commentTextview.text as String? {
            comment = commentVal
        }
        
        let medication = [
            "petId": petId,
            "productType": productType,
            "make": make,
            "amount": amount,
            "medicationDate": medDate,
            "cost": cost,
            "reminder": reminder,
            "comment": comment
        ]
        
        var route = ""
        if self.medication == nil {
            route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_MEDICATION)"
        } else {
            route = "\(ROUTE_MEDICATION)/\(self.medication.medicationId)"
        }
        
        self.saveMedication(medication, route: route)
    }
    
    func saveMedication(medication: [String:String], route: String) {
        RestApiManager.sharedInstance.postRequest(route, params: medication, onCompletion: {(json: JSON) -> () in
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
    
    @IBAction func medDateTapped(sender: AnyObject) {
        self.dateView.hidden = false
        self.dateFieldType = DATE_MEDICATION
    }
    
    @IBAction func dateDoneTapped(sender: AnyObject) {
        self.dateView.hidden = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let theDate = dateFormatter.stringFromDate(self.datePicker.date)
        
        if dateFieldType == DATE_MEDICATION {
            medDateTextfield.text = theDate
        } else {
            reminderTextfield.text = theDate
        }
        dateFieldType = ""
        self.dateView.hidden = true
    }
    
    @IBAction func reminderDateTapped(sender: AnyObject) {
        self.dateView.hidden = false
        self.dateFieldType = DATE_REMINDER
    }
    
    @IBAction func dateCancelTapped(sender: AnyObject) {
        self.dateView.hidden = true
        
    }
    
    @IBAction func typeFieldChanged(sender: AnyObject) {
        self.prodtypesTableview.hidden = false
        if let text = self.prodtypeTextfield.text as String? {
            
            auto.removeAll(keepCapacity: false)
            for curString in self.prodtypes
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
            self.prodtypesTableview.reloadData()
        } else {
            self.prodtypesTableview.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auto.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        let val = self.auto[indexPath.row]
        cell.textLabel!.text = val
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let prod = self.auto[indexPath.row]
        prodtypeTextfield.text = prod
        prodtypesTableview.hidden = true
    }
}
