//
//  ApperanceViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApperanceViewController: UIViewController {
    var dogId: String = ""
    
    @IBOutlet weak var colorTextfield: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
    }

    override func viewDidAppear(animated: Bool){
        getAppearance()
    }
    
    func getAppearance(){
        if dogId != "" {
            let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_APPEARANCE)"
            RestApiManager.sharedInstance.getRequest(route, params: "", onCompletion: { (json: JSON) -> () in
                if let status = json["status"].intValue as Int? {
                    if status == STATUS_OK {
                        if let appearance = json["data"] as JSON? {
                            if appearance != nil {
                                self.displayAppearance(appearance)
                            } else {
                                self.enableFields()
                            }
                        }
                    }
                }
            })
        } 
    }
    
    func displayAppearance(appearance: JSON){
        if appearance != [] {
            
        }
        var color = ""
        var height = ""
        var weight = ""
        var comment = ""
        
        if let colorVal = appearance["color"].stringValue as String? {
            color = colorVal
        }
        if let heightVal = appearance["heightInCm"].stringValue as String? {
            height = heightVal
        }
        if let weightVal = appearance["weightInKg"].stringValue as String? {
            weight = weightVal
        }
        if let commentVal = appearance["comment"].stringValue as String? {
            comment = commentVal
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.colorTextfield.text = color
            self.weightTextfield.text = weight
            self.heightTextfield.text = height
            self.commentTextview.text = comment
            
            self.colorTextfield.borderStyle = .None
            self.heightTextfield.borderStyle = .None
            self.weightTextfield.borderStyle = .None
            
            self.colorTextfield.enabled = false
            self.heightTextfield.enabled = false
            self.weightTextfield.enabled = false
            self.commentTextview.editable = false
            
        }
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.enableFields()
    }
    
    func enableFields() {
        self.colorTextfield.borderStyle = .RoundedRect
        self.heightTextfield.borderStyle = .RoundedRect
        self.weightTextfield.borderStyle = .RoundedRect
        
        self.colorTextfield.enabled = true
        self.heightTextfield.enabled = true
        self.weightTextfield.enabled = true
        self.commentTextview.editable = true
        
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
            "comment": comment
        ]
        
        let route = "\(ROUTE_MY_PETS)/\(dogId)/\(ROUTE_APPEARANCE)"
        RestApiManager.sharedInstance.postRequest(route, params: appearance, onCompletion: {(json: JSON) -> () in
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
}
