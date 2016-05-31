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
    }
    
    override func viewWillAppear(animated: Bool) {
        getIdentity()
    }
    
    func getIdentity(){
        let token = TokenController.getToken()
        let params = "dogid=\(dogId)&token=\(token)"
        
        RestApiManager.sharedInstance.getRequest(ROUTE_IDENTITY, params: params, onCompletion: { (json: JSON) -> () in
            print(json)
            var chip = ""
            var passport = ""
            var earmark = ""
            var comment = ""
            
            if json["identity"] != JSON.null {
                print("Has identity")
            
                if let chipVal = json["identity", "chip"].stringValue as String? {
                    chip = chipVal
                }
                if let passportVal = json["identity", "passport"].stringValue as String? {
                    passport = passportVal
                }
                if let earmarkVal = json["identity", "earmark"].stringValue as String? {
                    earmark = earmarkVal
                }
                if let commentVal = json["identity", "comment"].stringValue as String? {
                    comment = commentVal
                }
            
                self.displayIdentity(chip, passport: passport, earmark: earmark, comment: comment)
            }
        })
    }
    
    func displayIdentity(chip: String, passport: String, earmark: String, comment: String) {
        
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
        
        RestApiManager.sharedInstance.postRequest(ROUTE_IDENTITY, params: body, onCompletion: {(json: JSON) -> () in
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
    
    @IBAction func editButtonTapped(sender: AnyObject) {
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
