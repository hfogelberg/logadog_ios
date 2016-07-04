//
//  ApperanceViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApperanceViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    var petId: String = ""
    
    @IBOutlet weak var colorTextfield: UITextField!
    @IBOutlet weak var heightTextfield: UITextField!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var colorTableView: UITableView!
    
    var colors = [String]()
    var auto: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        
        self.colorTextfield.delegate = self
        self.colorTableView.delegate = self
        self.colorTableView.dataSource = self
    }

    override func viewDidAppear(animated: Bool){
        self.colorTableView.hidden = true
        getAppearance()
        getColors()
    }
    
    func getColors() {
        self.colors.removeAll()
        let route = "\(ROUTE_COLORS)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            print(json)
            if let colors = json["data"].array {
                for color in colors {
                    self.colors.append(ColorObject(json: color).name)
                }
            }
        })
    }
    
    func getAppearance(){
        if petId != "" {
            let route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_APPEARANCE)"
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
                } else {
                    
                    //ToDo: handle error response
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
        }
        
        self.disableFields()
    }
    
    func disableFields() {
        dispatch_async(dispatch_get_main_queue()) {
            self.editButton.enabled = true
            self.saveButton.enabled = false
    
            self.colorTextfield.borderStyle = .None
            self.heightTextfield.borderStyle = .None
            self.weightTextfield.borderStyle = .None
        
            self.colorTextfield.enabled = false
            self.heightTextfield.enabled = false
            self.weightTextfield.enabled = false
            self.commentTextview.editable = false
        
            self.editButton.enabled = true
            self.saveButton.enabled = false
        }
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        self.enableFields()
    }
    
    func enableFields() {
        self.saveButton.enabled = true
        self.editButton.enabled = false
        
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
            "petId": self.petId,
            "color": color,
            "heightInCm": height,
            "weightInKg": weight,
            "comment": comment
        ]
        
        let route = "\(ROUTE_PETS)/\(petId)/\(ROUTE_APPEARANCE)"
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
    
    @IBAction func colorFieldChanged(sender: AnyObject) {
        self.colorTableView.hidden = false
        if let text = colorTextfield.text as String? {
            
            auto.removeAll(keepCapacity: false)
            for curString in self.colors
            {
                let myString:NSString! = curString as NSString
                
                let substringRange :NSRange! = myString.rangeOfString(text)
                if (substringRange.location  == 0)
                {
                    auto.append(curString)
                }
            }
        }
        
        if auto.count > 0 {
            self.colorTableView.reloadData()
        } else {
            self.colorTableView.hidden = true
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let color = auto[indexPath.row]
        
        cell.textLabel!.text = color
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auto.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let color = self.auto[indexPath.row]
        self.colorTextfield.text = color
        self.colorTableView.hidden = true
    }
}
