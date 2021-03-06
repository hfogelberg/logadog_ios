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
    @IBOutlet weak var animaltypeTextfield: UITextField!
    @IBOutlet weak var animaltypeTableView: UITableView!
    
    var breeds = [String]()
    var animalTypes = [String]()
    var auto: [String] = []
    var gender = MALE
    var pet: PetObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        self.breedTableView.dataSource = self
        self.breedTableView.delegate = self
        self.breedTextfield.delegate = self
        self.breedTableView.hidden = true
        self.animaltypeTableView.delegate = self
        self.animaltypeTableView.dataSource = self
        self.animaltypeTableView.delegate = self
        
        // Don't use IQKeyboardManager for this field
        dobTextfield.inputAccessoryView = UIView()
        
        if pet != nil {
            showPet()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dateView.hidden = true
        self.animaltypeTableView.hidden = true
        self.breedTableView.hidden = true
        
        self.getDistinctBreeds()
        self.getAnimaltypes()
    }
    
    func getDistinctBreeds() {
        var animal = ""
        var route = ""
        
        if let animalVal = animaltypeTextfield.text as String? {
            animal = animalVal
        }
        if animal == "" {
            route = "\(ROUTE_BREEDS)?lang=\(DEFAULT_LANGUAGE)"
        } else {
            route = "\(ROUTE_BREEDS)?lang=\(DEFAULT_LANGUAGE)&animal=\(animal)"
        }
        print(route)
        
        self.breeds.removeAll()
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let breeds = json["data"].array {
                for breed in breeds {
                    self.breeds.append(BreedObject(json: breed).name)
                }
            }
        })
    }
    
    func getAnimaltypes() {
        self.animalTypes.removeAll()
        let route = "\(ROUTE_ANIMAL)?lang=\(DEFAULT_LANGUAGE)"
        
        RestApiManager.sharedInstance.getRequest(route, onCompletion: {(json:JSON)->() in
            if let animalTypes = json["data"].array {
                for type in animalTypes {
                    self.animalTypes.append(AnimaltypeObject(json: type).name)
                }
            }
        })
    }
    
    func showPet(){
        nameTextfield.text = pet.name
        animaltypeTextfield.text = pet.animaltype
        breedTextfield.text = pet.breed

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
    
    @IBAction func dobFieldTapped(sender: AnyObject) {
        print("Show date view")
        self.dateView.hidden = false
    }
    
    @IBAction func dobDonebuttonTapped(sender: AnyObject) {
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
        var animaltype = ""
        var body: [String:String]
        var dob = ""
        
        if let nameVal = nameTextfield.text as String? {
            name = nameVal
        }
        
        if let breedVal = breedTextfield.text as String? {
            breed = breedVal
        }
        
        if let animaltypeVal = animaltypeTextfield.text as String? {
            animaltype = animaltypeVal
        }
        
        if let dobVal = dobTextfield.text as String? {
            dob = dobVal
        }
        
        body = [
            "name": name,
            "breed": breed,
            "animaltype": animaltype,
            "gender": gender,
            "dob": dob,
            "userId": TokenController.getUserId()
        ]
        if pet == nil {
            route = ROUTE_PETS
        } else {
            route = "\(ROUTE_PETS)/\(self.pet.id)"
        }
        
        postJson(route, body: body)
    }
    
    func postJson(route: String, body:[String:String]) {
        RestApiManager.sharedInstance.postRequest(route, params: body, onCompletion: {(json: JSON) -> () in
            var status = STATUS_OK
            
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
    
    @IBAction func animaltypeChanged(sender: AnyObject) {
        print("Animal type tapped")
        self.breedTableView.hidden = true
        self.animaltypeTableView.hidden = false
        if let text = animaltypeTextfield.text as String? {
            
            auto.removeAll(keepCapacity: false)
            for curString in self.animalTypes
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
            self.animaltypeTableView.reloadData()
        } else {
            self.animaltypeTableView.hidden = true
        }
    }
    

    @IBAction func breedFieldChanged(sender: AnyObject) {
        print("Breed tapped")
        self.animaltypeTableView.hidden = true
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
        let data = self.auto[indexPath.row]
        cell.textLabel!.text = data
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let idx = indexPath.row
        let data = self.auto[idx]
        
        if tableView == breedTableView {
            self.breedTextfield.text = data
            self.breedTableView.hidden = true
        }
        
        if tableView == animaltypeTableView {
            self.animaltypeTextfield.text = data
            self.animaltypeTableView.hidden = true
            self.breedTextfield.text = ""
            self.getDistinctBreeds()
        }
    }
}
