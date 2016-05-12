//
//  NewDogViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-12.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class NewDogViewController: UIViewController, APIControllerProtocol {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    
    var gender = MALE
    
    var api : APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func genderChanged(sender: AnyObject) {
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
    

    @IBAction func saveButtonTapped(sender: AnyObject) {
        var name = ""
        var breed = ""
        var token: String? = nil
        var userId: String? = nil
        
        if let nameVal = self.nameTextField.text as String? {
            name = nameVal
        }
        
        if let breedVal = self.breedTextField.text as String? {
            breed = breedVal
        }
        
        if let tokenVal = TokenController.getToken() {
            token = tokenVal
        }
        
        if let userIdVal = TokenController.getUserId() {
            userId = userIdVal
        }
        
        let dog = Dog(name: name, breed: breed, gender: gender)
        
        if (token != nil && userId != nil) {
            createDog(dog, userId: userId!, token: token!)
        }
    }
    
    
    func createDog(dog: Dog, userId: String, token: String) {
        let params = "user_id=\(userId)&token=\(token)&name=\(dog.name)&gender=\(dog.gender)&breed=\(dog.breed)"
        
        self.api = APIController(delegate: self)
        let url =  ROUTE_DOGS + "/\(userId)/"
        self.api!.postJson(params, route: url)
    }
    
    
    func didRecieveAPIResults(status: Int, message: String, results: NSDictionary) {
        if status == TRUE {
            
        } else {
            print(message)
            // ToDo: Show error
        }
    }
}
