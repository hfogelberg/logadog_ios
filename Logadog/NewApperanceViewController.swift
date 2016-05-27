//
//  NewApperanceViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewApperanceViewController: UIViewController {
    var dogId: String = ""
    
    @IBOutlet weak var colorTextfield: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
        var color = ""
        var height = ""
        var weight = ""
        var comment = ""
        
        if let colorVal = self.colorTextfield.text as String? {
            color = colorVal
        }
        
        if let heightVal = self.heightTextfield.text as String? {
            height = heightVal
        }
        
        if let weightVal = self.weightTextfield.text as String? {
            weight = weightVal
        }
        
        if let commentVal = self.commentTextview.text as String? {
            comment = commentVal
        }
        
       let appearance = [
            "dogId": self.dogId,
            "color": color,
            "heightInCm": height,
            "weightInKg": weight,
            "comment": comment,
            "token": TokenController.getToken()
        ]
        
        RestApiManager.sharedInstance.updateDog(appearance, onCompletion: { (json: JSON) -> () in
            var status = STATUS_OK
            
            print(json)
            
            if let statusVal = json["status"].rawString() as String? {
                status = Int(statusVal)!
            }
            
            if status == STATUS_OK {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // ToDo: Dsiplay error message
                print("ERROR: \(status)")
            }
        })
    }
}
