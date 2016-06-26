//
//  ContactViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactViewController: UIViewController {
    
    var contactId = ""
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var webTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var postalcodeTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var commenttextview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contactId != "" {
            getContact()
        }
    }
    
    func getContact() {
        let route = "\(ROUTE_CONTACT)/\(self.contactId)"
        RestApiManager.sharedInstance.getRequest(route, onCompletion: { (json: JSON) -> () in
            print(json)
            self.displayContact(json)
        })
    }
    
    func displayContact(contact: JSON) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.nameTextfield.text = contact["name"].stringValue
            self.companyTextfield.text = contact["company"].stringValue
            self.webTextfield.text = contact["web"].stringValue
            self.emailTextfield.text = contact["email"].stringValue
            self.phoneTextfield.text = contact["phone"].stringValue
            self.streetTextfield.text = contact["street"].stringValue
            self.postalcodeTextfield.text = contact["postalcode"].stringValue
            self.cityTextfield.text = contact["city"].stringValue
            self.countryTextfield.text = contact["country"].stringValue
            self.commenttextview.text = contact["comment"].stringValue
            
            self.nameTextfield.borderStyle = .None
            self.companyTextfield.borderStyle = .None
            self.webTextfield.borderStyle = .None
            self.emailTextfield.borderStyle = .None
            self.phoneTextfield.borderStyle = .None
            self.streetTextfield.borderStyle = .None
            self.postalcodeTextfield.borderStyle = .None
            self.cityTextfield.borderStyle = .None
            self.countryTextfield.borderStyle = .None
            
            self.nameTextfield.enabled = false
            self.companyTextfield.enabled = false
            self.webTextfield.enabled = false
            self.emailTextfield.enabled = false
            self.phoneTextfield.enabled = false
            self.streetTextfield.enabled = false
            self.postalcodeTextfield.enabled = false
            self.cityTextfield.enabled = false
            self.countryTextfield.enabled = false
            self.commenttextview.editable = false
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var name = "";
        var company = "";
        var web = "";
        var email = "";
        var phone = "";
        var street = "";
        var postalcode = "";
        var city = "";
        var country = "";
        var comment = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        if let companyVal = companyTextfield.text as String? {
            company = companyVal
        }
        if let webVal = webTextfield.text as String? {
            web = webVal
        }
        if let emailVal = emailTextfield.text as String? {
            email = emailVal
        }
        if let phoneVal = phoneTextfield.text as String? {
            phone = phoneVal
        }
        if let streetVal = streetTextfield.text as String? {
            street = streetVal
        }
        if let postalcodeVal = postalcodeTextfield.text as String? {
            postalcode = postalcodeVal
        }
        if let cityVal = cityTextfield.text as String? {
            city = cityVal
        }
        if let countryVal = countryTextfield.text as String? {
            country = countryVal
        }
        if let commentVal = commenttextview.text as String? {
            comment = commentVal
        }
        
        var contact = [
            "name": name,
            "company": company,
            "web": web,
            "email": email,
            "phone": phone,
            "street": street,
            "postalcode": postalcode,
            "city": city,
            "country": country,
            "comment": comment,
        ]
        
        var route = ""
        if contactId != "" {
            route = "\(ROUTE_CONTACT)/\(self.contactId)"
            
        } else {
            route = "\(ROUTE_CONTACT)"
        }
    
        RestApiManager.sharedInstance.postRequest(route, params: contact, onCompletion: {(json: JSON) -> () in
            var status = ""
            
            if let statusVal = json["status"].rawString() as String? {
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
    

    
    @IBAction func editButtonTapped(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.nameTextfield.enabled = true
            self.companyTextfield.enabled = true
            self.webTextfield.enabled = true
            self.emailTextfield.enabled = true
            self.phoneTextfield.enabled = true
            self.streetTextfield.enabled = true
            self.postalcodeTextfield.enabled = true
            self.cityTextfield.enabled = true
            self.countryTextfield.enabled = true
            self.commenttextview.editable = true
            
            self.nameTextfield.borderStyle = .RoundedRect
            self.companyTextfield.borderStyle = .RoundedRect
            self.webTextfield.borderStyle = .RoundedRect
            self.emailTextfield.borderStyle = .RoundedRect
            self.phoneTextfield.borderStyle = .RoundedRect
            self.streetTextfield.borderStyle = .RoundedRect
            self.postalcodeTextfield.borderStyle = .RoundedRect
            self.cityTextfield.borderStyle = .RoundedRect
            self.countryTextfield.borderStyle = .RoundedRect
        }
    }
}
