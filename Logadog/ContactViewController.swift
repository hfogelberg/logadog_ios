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
        
        let contact = [
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
        
        let route = "\(ROUTE_CONTACT)"
        RestApiManager.sharedInstance.postRequest(route, params: contact, onCompletion: {(json: JSON) -> () in
            var status = ""
            
            print(json)
            
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

    @IBOutlet weak var editButtonTapped: UIBarButtonItem!

}
