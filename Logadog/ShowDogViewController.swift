//
//  ShowDogViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class ShowDogViewController: UIViewController {
    
    var dog: DogObject!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var appearanceButton: UIButton!
    @IBOutlet weak var identityButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        identityButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        appearanceButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        
        showDog()
    }
    
    func showDog() {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        genderLabel.text = dog.gender
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "appearanceSegue" {
            let nextScene = segue.destinationViewController as! ApperanceViewController
            nextScene.dogId = dog.id
        } else if segue.identifier == "changeDogSegue" {
            let nextScene = segue.destinationViewController as! DogViewController
            nextScene.dog = dog
        } else if segue.identifier == "identitySegue" {
            let nextScene = segue.destinationViewController as! IdentityViewController
            nextScene.dogId = dog.id
        }
    }
}
