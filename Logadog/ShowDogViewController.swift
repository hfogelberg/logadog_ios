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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDog()
    }
    
    func showDog() {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        genderLabel.text = dog.gender
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "appearanceSegue" {
            let nextScene = segue.destinationViewController as! NewApperanceViewController
            nextScene.dogId = dog.id
        } else if segue.identifier == "changeDogSegue" {
            let nextScene = segue.destinationViewController as! AddDogViewController
            nextScene.dog = dog
        }
    }
}
