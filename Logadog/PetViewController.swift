//
//  PetViewController
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManager

class PetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var breedTextfield: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var dobTextfield: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var breedTableView: UITableView!
    
    var breeds = [String]()
    var auto: [String] = []
    var gender = MALE
    var dog: DogObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        self.breedTableView.dataSource = self
        self.breedTableView.delegate = self
        self.breedTextfield.delegate = self
        self.breedTableView.hidden = true
         
        // Don't use IQKeyboardManager for this field
        dobTextfield.inputAccessoryView = UIView()
        
        if dog != nil {
            showDog()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dateView.hidden = true
        
        self.getDistinctBreeds()
    }

    
    func getDistinctBreeds() {
        self.breeds.removeAll()
        let route = "\(ROUTE_BREEDS)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            print(json)
            if let breeds = json["data"].array {
                for breed in breeds {
                    self.breeds.append(BreedObject(json: breed).name)
                }
            }
        })
    }
    
    func showDog(){
        nameTextfield.text = dog.name
        breedTextfield.text = dog.breed

        if gender == MALE {
            self.genderSwitch.selectedSegmentIndex = 0
        } else {
            self.genderSwitch.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func genderSwitchChanged(sender: AnyObject) {
        switch genderSwitch.selectedSegmentIndex
        {
        case 0:
            self.gender = MALE
        case 1:
            self.gender = FEMALE
        default:
            break;
        }
    }
    
    @IBAction func dobTextfieldTappd(sender: AnyObject) {
        self.dateView.hidden = false
    }
    
    @IBAction func dobDoneButtonTapped(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dobDate = dateFormatter.stringFromDate(dobPicker.date)
        dobTextfield.text = dobDate
        self.dateView.hidden = true
    }
    
    @IBAction func dobCancelTapped(sender: AnyObject) {
        self.dateView.hidden = true
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        var name = ""
        var breed = ""
        var route = ""
        var body: [String:String]
        var dob = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        
        if let breedVal = breedTextfield.text as String? {
            breed = breedVal
        }
        
        if let dobVal = dobTextfield.text as String? {
            dob = dobVal
        }
        
        print("Date of birth: \(dob)")
        
        if dog == nil {
            body = [
                "name": name,
                "breed": breed,
                "gender": gender,
                "dob": dob,
                "userId": TokenController.getUserId()
            ]
            
            route = ROUTE_PETS
        } else {
            body = [
                "name": name,
                "breed": breed,
                "gender": gender,
                "dob": dob,
                "dogid": self.dog.id
            ]
            
            route = ROUTE_CHANGE_DOG
        }
        
        postJson(route, body: body)
    }
    
    func postJson(route: String, body:[String:String]) {
        RestApiManager.sharedInstance.postRequest(route, params: body, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            print(json)
            
            if let statusVal = json["status"].numberValue as Int? {
                status = statusVal
            }
            
            if status == STATUS_OK {
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationController?.popToRootViewControllerAnimated(true)
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
    
    @IBAction func breedFieldChanged(sender: AnyObject) {
        self.breedTableView.hidden = false
        if let text = breedTextfield.text as String? {
            
            auto.removeAll(keepCapacity: false)
            for curString in self.breeds
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
            self.breedTableView.reloadData()
        } else {
            self.breedTableView.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.auto.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let breed = self.auto[indexPath.row]
        cell.textLabel!.text = breed
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let idx = indexPath.row
        let breed = self.auto[idx]
        self.breedTextfield.text = breed
        self.breedTableView.hidden = true
    }
}
