//
//  DogViewController.swift
//  logadog
//
//  Created by Henrik Fogelberg on 2016-05-04.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {
    var dog: Dog?
    @IBOutlet weak var breedLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let d = dog {
            self.navigationItem.title = d.name
            self.breedLabel.text = d.breed
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
