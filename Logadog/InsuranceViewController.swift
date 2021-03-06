//
//  InsuranceViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-01.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class InsuranceViewController: UIViewController {
    var petId = ""

    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var productTextfield: UITextField!
    @IBOutlet weak var insuranceNumberTextfield: UITextField!
    @IBOutlet weak var renewaldateTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var vetTextfield: UITextField!
    @IBOutlet weak var lifeTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        // Don't use IQKeyboardManager for this field
        renewaldateTextfield.inputAccessoryView = UIView()

        getInsurance()
    }
    
    override func viewWillAppear(animated: Bool) {
        dateView.hidden = true
    }
    
    func getInsurance() {
        if petId != "" {
            let route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_INSURANCE)"
            
            RestApiManager.sharedInstance.getRequest(route, onCompletion: { (json: JSON) -> () in
                if let status = json["status"].intValue as Int? {
                    if status == STATUS_OK {
                        if let insurance = json["data"] as JSON? {
                            if insurance != nil {
                                self.displayInsurance(insurance)
                            } else {
                                self.enableFields()
                            }
                        }
                    }
                } else {
                    //ToDo: handle error response
                }
            })
        }
    }
    
    func displayInsurance(insurance: JSON) {
        var company = ""
        var product = ""
        var insuranceNumber = ""
        var renewalDate = ""
        var anualCost = ""
        var lifeAmount = ""
        var vetAmount = ""
        var comment = ""
        
        print("Has insurance")
    
        if let companyVal = insurance["company"].stringValue as String? {
            company = companyVal
        }
        if let productVal = insurance["product"].stringValue as String? {
            product = productVal
        }
        if let numVal = insurance["number"].stringValue as String? {
            insuranceNumber = numVal
        }
        if let dateVal = insurance["renewalDate"].stringValue as String? {
            renewalDate = dateVal
        }
        if let costVal = insurance["anualCost"].stringValue as String? {
            anualCost = costVal
        }
        if let vetVal = insurance["vetAmount"].stringValue as String? {
            vetAmount = vetVal
        }
        if let lifeVal = insurance["renewalDate"].stringValue as String? {
            lifeAmount = lifeVal
        }
        if let commentVal = insurance["comment"].stringValue as String? {
            comment = commentVal
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.companyTextfield.text = company
            self.productTextfield.text = product
            self.insuranceNumberTextfield.text = insuranceNumber
            self.renewaldateTextfield.text = renewalDate
            self.costTextfield.text = anualCost
            self.lifeTextfield.text = lifeAmount
            self.vetTextfield.text = vetAmount
            self.commentTextview.text = comment
        }
        
        self.disableFields()
    }
    
    func disableFields()
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.companyTextfield.borderStyle = .None
            self.productTextfield.borderStyle = .None
            self.insuranceNumberTextfield.borderStyle = .None
            self.renewaldateTextfield.borderStyle = .None
            self.costTextfield.borderStyle = .None
            self.lifeTextfield.borderStyle = .None
            self.vetTextfield.borderStyle = .None
            
            self.companyTextfield.enabled = false
            self.productTextfield.enabled = false
            self.insuranceNumberTextfield.enabled = false
            self.renewaldateTextfield.enabled = false
            self.costTextfield.enabled = false
            self.lifeTextfield.enabled = false
            self.vetTextfield.enabled = false
            self.commentTextview.editable = false
            
            self.editButton.enabled = true
            self.saveButton.enabled = false
        }
    }
    
    @IBAction func renewaldateTapped(sender: AnyObject) {
        dateView.hidden = false
    }
    
    @IBAction func dateDoneTapped(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(datePicker.date)
        renewaldateTextfield.text = date
        dateView.hidden = true
    }
    
    @IBOutlet weak var dateCancelTapped: UIBarButtonItem!
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.enableFields()
    }
    
    func enableFields() {
        self.companyTextfield.borderStyle = .RoundedRect
        self.productTextfield.borderStyle = .RoundedRect
        self.insuranceNumberTextfield.borderStyle = .RoundedRect
        self.renewaldateTextfield.borderStyle = .RoundedRect
        self.costTextfield.borderStyle = .RoundedRect
        self.lifeTextfield.borderStyle = .RoundedRect
        self.vetTextfield.borderStyle = .RoundedRect
        
        self.companyTextfield.enabled = true
        self.productTextfield.enabled = true
        self.insuranceNumberTextfield.enabled = true
        self.renewaldateTextfield.enabled = true
        self.costTextfield.enabled = true
        self.lifeTextfield.enabled = true
        self.vetTextfield.enabled = true
        self.commentTextview.editable = true
        
        self.editButton.enabled = false
        self.saveButton.enabled = true
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var company = ""
        var product = ""
        var insuranceNumber = ""
        var renewalDate = ""
        var anualCost = ""
        var lifeAmount = ""
        var vetAmount = ""
        var comment = ""
        
        if let comapanyVal = companyTextfield.text as String? {
            company = comapanyVal
        }
        
        if let productVal = productTextfield.text as String? {
            product = productVal
        }
        
        if let numVal = insuranceNumberTextfield.text as String? {
            insuranceNumber = numVal
        }
        
        if let costVal = costTextfield.text as String? {
            anualCost = costVal
        }
        
        if let dateVal = renewaldateTextfield.text as String? {
            renewalDate = dateVal
        }
        
        if let vetVal = vetTextfield.text as String? {
            vetAmount = vetVal
        }
        
        if let lifeVal = lifeTextfield.text as String? {
            lifeAmount = lifeVal
        }
        
        if let commentVal = commentTextview.text as String? {
            comment = commentVal
        }
        
        
        let params = [
            "company": company,
            "product": product,
            "number": insuranceNumber,
            "lifeAmount": lifeAmount,
            "vetAmount": vetAmount,
            "renewalDate": renewalDate,
            "anualCost": anualCost,
            "comment": comment,
            "petId": self.petId,
            "token": TokenController.getToken()
        ]
        
        let route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_INSURANCE)"
        
        RestApiManager.sharedInstance.postRequest(route, params: params, onCompletion: {(json:JSON) -> () in
            // Todo: Handle response
            print(json)
        })
    }
}
