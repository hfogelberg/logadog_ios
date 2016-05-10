//
//  StartViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-09.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("StartViewController")
        
        if TokenController.hasToken() {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("dogsListSegue", sender: self)
            }
        }
    }
}
