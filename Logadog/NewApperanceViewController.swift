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

    override func viewDidAppear(animated: Bool){
        self.commentTextview.scrollRangeToVisible(NSMakeRange(0, 0))
        
        if dogId != "" {
            
            let token = TokenController.getToken()
            let params = "dogid=\(dogId)&token=\(token)"
            
                RestApiManager.sharedInstance.getRequest(ROUTE_APPEARANCE, params: params, onCompletion: { (json: JSON) -> () in
                    dispatch_async(dispatch_get_main_queue()) {
                        let dog = json["dog"]
                        print(dog["color"].stringValue)
                    
                            
                        self.colorTextfield.text = dog["color"].stringValue
                        self.heightTextfield.text = dog["heightInCm"].stringValue
                        self.weightTextfield.text = dog["weightInKg"].stringValue
                        self.commentTextview.text = dog["comment"].stringValue

                        self.colorTextfield.enabled = false
                        self.heightTextfield.enabled = false
                        self.weightTextfield.enabled = false
                        self.commentTextview.editable = false
                        
                    }
                    
                })
        }
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.colorTextfield.enabled = true
        self.heightTextfield.enabled = true
        self.weightTextfield.enabled = true
        self.commentTextview.editable = true
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
        
        RestApiManager.sharedInstance.postRequest(ROUTE_APPEARANCE, params: appearance, onCompletion: {(json: JSON) -> () in
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
}
