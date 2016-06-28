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
    var dogId = ""

    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var productTextfield: UITextField!
    @IBOutlet weak var insuranceNumberTextfield: UITextField!
    @IBOutlet weak var renewaldateTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var vetTextfield: UITextField!
    @IBOutlet weak var lifeTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        self.saveButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)

        getInsurance()
    }
    
    func getInsurance() {
        if dogId != "" {
            let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_INSURANCE)"
            
            RestApiManager.sharedInstance.getRequest(route, onCompletion: { (json: JSON) -> () in
                print(json)
                if let insurance = json["data", "insurance"] as JSON? {
                    self.displayInsurance(insurance)
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
        
        if let companyVal = insurance["insurance", "company"].stringValue as String? {
            company = companyVal
        }
        if let productVal = insurance["insurance", "product"].stringValue as String? {
            product = productVal
        }
        if let numVal = insurance["insurance", "number"].stringValue as String? {
            insuranceNumber = numVal
        }
        if let dateVal = insurance["insurance", "renewalDate"].stringValue as String? {
            renewalDate = dateVal
        }
        if let costVal = insurance["insurance", "anualCost"].stringValue as String? {
            anualCost = costVal
        }
        if let vetVal = insurance["insurance", "vetAmount"].stringValue as String? {
            vetAmount = vetVal
        }
        if let lifeVal = insurance["insurance", "renewalDate"].stringValue as String? {
            lifeAmount = lifeVal
        }
        if let commentVal = insurance["insurance", "comment"].stringValue as String? {
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
        }
    }
    
    
    @IBAction func editButtonTapped(sender: AnyObject) {
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
            "dogid": self.dogId,
            "token": TokenController.getToken()
        ]
        
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_INSURANCE)"
        
        RestApiManager.sharedInstance.postRequest(route, params: params, onCompletion: {(json:JSON) -> () in
            // Todo: Handle response
            print(json)
        })
    }
}
