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
            let token = TokenController.getToken()
            let params = "dogid=\(dogId)&token=\(token)"
            
            RestApiManager.sharedInstance.getRequest(ROUTE_INSURANCE, params: params, onCompletion: { (json: JSON) -> () in
                print(json)
                if json["insurance"] != JSON.null {
                    var company = ""
                    var product = ""
                    var insuranceNumber = ""
                    var renewalDate = ""
                    var anualCost = ""
                    var lifeAmount = ""
                    var vetAmount = ""
                    var comment = ""
                    
                    print("Has insurance")
                    
                    if let companyVal = json["insurance", "company"].stringValue as String? {
                        company = companyVal
                    }
                    if let productVal = json["insurance", "product"].stringValue as String? {
                        product = productVal
                    }
                    if let numVal = json["insurance", "number"].stringValue as String? {
                        insuranceNumber = numVal
                    }
                    if let dateVal = json["insurance", "renewalDate"].stringValue as String? {
                        renewalDate = dateVal
                    }
                    if let costVal = json["insurance", "anualCost"].stringValue as String? {
                        anualCost = costVal
                    }
                    if let vetVal = json["insurance", "vetAmount"].stringValue as String? {
                        vetAmount = vetVal
                    }
                    if let lifeVal = json["insurance", "renewalDate"].stringValue as String? {
                        lifeAmount = lifeVal
                    }
                    if let commentVal = json["insurance", "comment"].stringValue as String? {
                        comment = commentVal
                    }
                    
                    self.displayInsurance(company, product: product, insuranceNumber: insuranceNumber, renewalDate: renewalDate, anualCost: anualCost, lifeAmount: lifeAmount, vetAmount: vetAmount, comment: comment)
                }
                
            })
        }
    }
    
    func displayInsurance(company: String, product: String, insuranceNumber: String, renewalDate: String, anualCost: String, lifeAmount: String, vetAmount: String, comment: String) {
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
        
        RestApiManager.sharedInstance.postRequest(ROUTE_INSURANCE, params: params, onCompletion: {(json:JSON) -> () in
            print(json)
        })
    }
}