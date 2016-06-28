//
//  IdentityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-30.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class IdentityViewController: UIViewController {
    @IBOutlet weak var chipmarkTextfield: UITextField!
    @IBOutlet weak var earmarktextfield: UITextField!
    @IBOutlet weak var passportTextfield: UITextField!
    @IBOutlet weak var commenttextview: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var dogId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
    }
    
    override func viewWillAppear(animated: Bool) {
        getIdentity()
    }
    
    func getIdentity(){
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_IDENTITY)"
        RestApiManager.sharedInstance.getRequest(route, onCompletion: { (json: JSON) -> () in
            print(json)
            
            if let identity = json["data", "identity"] as JSON? {
                self.displayIdentity(identity)
            } else {
                self.enableFields()
            }
        })
    }
    
    func displayIdentity(identity: JSON) {
        var chip = ""
        var passport = ""
        var earmark = ""
        var comment = ""
        
        if let chipVal = identity["chip"].stringValue as String? {
            chip = chipVal
        }
        if let passportVal = identity["passport"].stringValue as String? {
            passport = passportVal
        }
        if let earmarkVal = identity["earmark"].stringValue as String? {
            earmark = earmarkVal
        }
        if let commentVal = identity["comment"].stringValue as String? {
            comment = commentVal
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.chipmarkTextfield.borderStyle = .None
            self.passportTextfield.borderStyle = .None
            self.earmarktextfield.borderStyle = .None
        
            self.chipmarkTextfield.enabled = false
            self.passportTextfield.enabled = false
            self.earmarktextfield.enabled = false
            self.commenttextview.editable = false
        
            self.chipmarkTextfield.text = chip
            self.passportTextfield.text = passport
            self.earmarktextfield.text = earmark
            self.commenttextview.text = comment
        
            self.saveButton.hidden = true
        }
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        print("Save identity")
        
        var chip = ""
        var earmark = ""
        var passport = ""
        var comment = ""
        var body: [String:String]
        
        if let chipVal = self.chipmarkTextfield.text as String? {
            chip = chipVal
        }
        
        if let earVal = self.earmarktextfield.text as String? {
            earmark = earVal
        }
        
        if let passportVal = self.passportTextfield.text as String? {
            passport = passportVal
        }
        
        if let commentVal = self.commenttextview.text as String? {
            comment = commentVal
        }
        
        
        print(comment)
        
        body = [
            "chip": chip,
            "earmark": earmark,
            "passport": passport,
            "comment": comment,
            "dogid": dogId,
            "token": TokenController.getToken()
        ]
        
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_IDENTITY)"
        RestApiManager.sharedInstance.postRequest(route, params: body, onCompletion: {(json: JSON) -> () in
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
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.enableFields()
    }
    
    func enableFields() {
        dispatch_async(dispatch_get_main_queue()) {
            self.chipmarkTextfield.borderStyle = .RoundedRect
            self.passportTextfield.borderStyle = .RoundedRect
            self.earmarktextfield.borderStyle = .RoundedRect
        
            self.chipmarkTextfield.enabled = true
            self.passportTextfield.enabled = true
            self.earmarktextfield.enabled = true
            self.commenttextview.editable = true
        
            self.saveButton.hidden = false
        }
    }
}
