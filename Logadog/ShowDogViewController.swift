//
//  ShowDogViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class ShowDogViewController: UIViewController {
    
    var pet: PetObject!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var appearanceButton: UIButton!
    @IBOutlet weak var identityButton: UIButton!
    @IBOutlet weak var insuranceButton: UIButton!
    @IBOutlet weak var medicationButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        identityButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        appearanceButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        insuranceButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        medicationButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        activitiesButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        
        showDog()
    }
    
    func showDog() {
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
        genderLabel.text = pet.gender
        dobLabel.text = pet.dob
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "appearanceSegue" {
            let nextScene = segue.destinationViewController as! ApperanceViewController
            nextScene.petId = pet.id
        } else if segue.identifier == "changeDogSegue" {
            let nextScene = segue.destinationViewController as! PetViewController
            nextScene.pet = pet
        } else if segue.identifier == "identitySegue" {
            let nextScene = segue.destinationViewController as! IdentityViewController
            nextScene.petId = pet.id
        } else if segue.identifier == "insuranceSegue" {
            let nextScene = segue.destinationViewController as! InsuranceViewController
            nextScene.petId = pet.id
        } else if segue.identifier == "medicationSegue" {
            let nextScene = segue.destinationViewController as! MedicationTableViewController
            nextScene.petId = pet.id
        } else if segue.identifier == "activitiesSegue" {
            let nextScene = segue.destinationViewController as! ActivitiesTableViewController
            nextScene.petId = pet.id
        }
    }
}
