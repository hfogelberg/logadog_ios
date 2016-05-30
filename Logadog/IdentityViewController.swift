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
    
    var dogId = ""
    
    override func viewDidLoad() {
        print("IdentityVC")
        super.viewDidLoad()
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
        
        body = [
            "chip": chip,
            "earmark": earmark,
            "passport": passport,
            "comment": comment,
            "dogid": dogId,
            "token": TokenController.getToken()
        ]
        
        RestApiManager.sharedInstance.postRequest(ROUTE_IDENTITY, params: body, onCompletion: {(json: JSON) -> () in
            print(json)
        })
    }
}
